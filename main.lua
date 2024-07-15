-- SETUP ---------------------------------------------------------------------------------------------------------------

display.setDefault("background", 1)

------------------------------------------------------------------------------------------------------------------------
-- RUN GAME --
------------------------------------------------------------------------------------------------------------------------

require("Breakpoints")

local circle = display.newCircle(100, 100, 10)
circle:setFillColor(1, 0, 0)
transition.loop(circle, {
    time       = 1000,
    x          = 200,
    iterations = 0,
    transition = easing.inOutSine,
})


local c = 0
Runtime:addEventListener("enterFrame", function()
    c = c + 1
    if c == 100 then
        breakpoint(1, function()
            print(c, circle.x, circle.y)

            return true
        end)
    end
end)

