# Solar2D - Breakpoints

This utility enables the integration of breakpoints into Solar2D projects. Breakpoints are essential for debugging, allowing developers to pause execution and inspect variables at specific code locations. Solar2D does not natively support breakpoints, and this tool provides a workaround to simulate this functionality.

## Installation

1. **Download:** Obtain the `breakpoints.lua` file from this repository.
2. **Add to Project:** Incorporate the file into your Solar2D project.
3. **Include in Code:** Import `breakpoints.lua` in your `main.lua` or in other Lua files where debugging is required.

    ```lua
    require("breakpoints")
    ```

## Usage

Insert the following line at the desired points in your code to set a breakpoint:

```lua
breakpoint(id, fn)
```

- `id` (number): A unique identifier for each breakpoint within a file.
- `fn` (function): A callback function for inspecting variables when the breakpoint is triggered.

### How it Works

Upon reaching a breakpoint, the Solar2D simulator pauses execution, and the console displays the line where the breakpoint was set. To inspect or modify variables, you need to edit the callback function in your code file directly.

- **Edit and Continue**: Modify the callback function to inspect or change the values of variables. After making changes, ensure the callback function returns `true` and save the file (`Ctrl+S`) to continue execution.

**Note**: The scope of variables is fixed once the file is loaded. You cannot introduce new variables at the breakpoint; you can only manipulate variables that already exist in the function's scope.

### Example Usage

```lua
local function doSomeWork()
    local x = 10
    local y = 20
    local z = x + y

    breakpoint(1, function()
        print("x: " .. x)  -- Inspect x
        print("y: " .. y)  -- Inspect y
        print("z: " .. z)  -- Inspect z
        return true  -- Continue execution after inspection
    end)

    print("The sum of x and y is: " .. z)
end

doSomeWork()
```

## Ownership and License

**Creator**: Depilz  
**Company**: Studycat Limited  
This tool is made available as open-source under the MIT License, facilitating both personal use and community development.
