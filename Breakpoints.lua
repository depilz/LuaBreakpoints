local projectRoot = system.pathForFile("", system.ResourceDirectory)

local function getlocalsAtLevel(level, locals)
    local i = 1
    while true do
        local name, value = debug.getlocal(level, i)
        if not name then break end
        if locals[name] == nil then
            locals[name] = value
        end
        i = i + 1
    end
end

local function getLocals(level)
    local locals = {}
    local success, l
    repeat
        success, l = pcall(getlocalsAtLevel, level, locals)
        level = level + 1
    until not success

    return locals
end

local function getUpvalues(f)
    local i = 1
    local upvalues = {}
    while true do
        local name, value = debug.getupvalue(f, i)
        if not name then break end
        upvalues[name] = value
        i = i + 1
    end
    return upvalues
end

local function getEnv(f)
    -- lets save all the local values from the original function
    local locals = getLocals(6)
    local upvalues = getUpvalues(f)

    local env = {}
    -- let's set the globals
    for k, v in pairs(_G) do
        env[k] = v
    end
    
    -- let's set the locals
    for k, v in pairs(locals) do
        env[k] = v
    end

    -- let's set the upvalues
    for k, v in pairs(upvalues) do
        env[k] = v
    end

    return env
end

local s = "> "
local function consolePrint(...)
    print(s, ...)
    s = "  "
end

function _G.breakpoint(n, f)
    if not f then
        f = n
        n = nil
    end
    -- lets save all the local values from the original function

    local env = getEnv(f)

    local file = debug.getinfo(f, "S").source
        :gsub(projectRoot, "")
        :sub(2)
        
    local absPath = system.pathForFile(file)

    local function reload()
        local f = io.open(absPath, "r")
        local content = f:read("*all")
        f:close()

        local breakpointCall
        if n then
            breakpointCall = content:match("breakpoint%(%s*"..n.."%s*,%s*function%s*%(%s*%)(.-)end%s*%)")
        else
            breakpointCall = content:match("breakpoint%(%s*function%s*%(%s*%)(.-)end%s*%)")
        end

        if breakpointCall then
            local f = loadstring(breakpointCall)
            
            setfenv(f, env)
            s = "> "
            env.print = consolePrint

            local success, msg = pcall(f)
            if success then
                print(" ")
                return msg
            else
                print("Error in breakpoint: " .. msg)
            end
        end
    end

    local lfs = require("lfs")
    local lastModified = lfs.attributes(absPath).modification
    local function wasModified()
        local attributes = lfs.attributes(absPath)
        local modified = attributes.modification
        if modified ~= lastModified then
            lastModified = modified
            return true
        end
    end

    local function shouldResume()
        if not wasModified() then 
            return false
        end
        
        return reload()
    end




    local trace = debug.traceback("", 2)

    -- third line is the function call
    local line = trace:match(":(%d+):")
    
    -- let's add some emojis letting the user know we hit a breakpoint
    -- with some clear indications
    print(" ")
    print(" ")
    print("🔴 Breakpoint at: " .. file .. ":" .. line)


    while not shouldResume() do
        os.execute("sleep 0.01")
    end
end
