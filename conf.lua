function love.conf(t)

    t.version = "11.3"
    t.window.width = 1000
    t.window.height = 500

    t.window.title = "Dino :D"
    t.window.icon = "data/Sprites/icon.png"

    t.identity = "data/Saves"

    t.console = true

    t.window.borderless = false
    t.window.fullscreen = false
    t.window.fullscreentype = "desktop"
    t.window.display = 1
    t.window.borderless = false
    t.window.resizable = false
    t.window.vsync = 1

    t.window.highdpi = false

    t.window.x = nil
    t.window.y = nil

    t.modules.joystick = false
    t.modules.physics = false
    t.modules.touch = false
    t.modules.video = false
    t.modules.thread = false
end