local SeedCreatingValue = os.time()

local Score = 0

local GameOver = false
---------

local width, height = love.graphics.getDimensions()

local mouseX, mouseY = 0, 0

local ColorForEndScreen = 0.3

local GroundStartPos = -100
local Grounds = {}
local GroundY = 400

local GroundImg
local SpikeImage

local animation
local ExtraY = 0

local Spikes = {}
local SpawnStopwatch = 0
local SpawnTimer = 1.8

local HeldJumpingButton = 0
local MaxHeld = 0.2
local fallingStopwatch = 0

function love.load()

    mouseX, mouseY = love.mouse.getPosition()

    print("Seed: " .. SeedCreatingValue)

    love.mouse.setVisible(true)

    GroundImg = love.graphics.newImage("data/Sprites/Terrain.png")
    SpikeImage = love.graphics.newImage("data/Sprites/Idle.png")

    for i = 1, 30, 1 do
        local temp = {x = 0, y = 0}
        table.insert(Grounds, temp)
    end

    animation = NewAnimation(love.graphics.newImage("data/Sprites/sheet.png"), 32, 32, 1)
end

function love.draw()

    mouseX, mouseY = love.mouse.getPosition()

    if GameOver
    then
        --Kill count shower
        love.graphics.push()
        love.graphics.setColor(0.1, 0.1, 0.1)
        love.graphics.rectangle("fill", (width / 2) - 63, 150 - 23, 126, 46)
        love.graphics.pop()

        love.graphics.push()
        love.graphics.setColor(1, 1, 1)
        love.graphics.rectangle("fill", (width / 2) - 60, 150 - 20, 120, 40)
        love.graphics.pop()

        love.graphics.push()
        love.graphics.setColor(1, 0, 0)
        love.graphics.print("Score: " .. Score, width / 2, 150, 0, 1.25, 1.25, 35, 8)
        love.graphics.pop()

        --Game Over button
        love.graphics.push()
        love.graphics.setColor(0.1, 0.1, 0.1)
        love.graphics.rectangle("fill", (width / 2) - 83, (height / 2) - 33, 166, 66)
        love.graphics.pop()

        love.graphics.push()
        love.graphics.setColor(ColorForEndScreen, ColorForEndScreen, ColorForEndScreen)
        love.graphics.rectangle("fill", (width / 2) - 80, (height / 2) - 30, 160, 60)
        love.graphics.pop()

        love.graphics.push()
        love.graphics.setColor(1, 0, 0)
        love.graphics.print("Game Over", width / 2, height / 2, 0, 2, 2, 33, 8)
        love.graphics.pop()
    else
        love.graphics.push()
        love.graphics.setColor(1, 1, 1)
        love.graphics.print("Score: " .. Score, 500, 10, 0, 1.25, 1.25, 35, 8)
        love.graphics.pop()

        for k,v in pairs(Grounds)
        do
            love.graphics.push()
            love.graphics.draw(GroundImg, v.x, v.y, 0, 2, 2)
            love.graphics.pop()
        end
        
        love.graphics.push()
        local spriteNum = math.floor(animation.currentTime / animation.duration * #animation.quads) + 1
        love.graphics.draw(animation.spriteSheet, animation.quads[spriteNum], 100, 310 + ExtraY, 0, 3.5)
        love.graphics.pop()

        for k,v in pairs(Spikes)
        do
            love.graphics.push()
            love.graphics.setColor(1, 1, 1)
            love.graphics.draw(SpikeImage, v.x, v.y, 0, 2, 2)
            love.graphics.pop()
        end
    end
end

function love.update(dt)

    if GameOver
    then
        if mouseX > (width / 2) - 85 and mouseX < (width / 2) + 85 and
        mouseY > (height / 2) - 45 and mouseY < (height / 2) + 45 then

            ColorForEndScreen = 0.9

            --resets the game
            if love.mouse.isDown(1) then

                ResetGame()
            end
        else
            ColorForEndScreen = 0.3
        end
    else
        ------------------------------------------------------------
        Score = Score + dt * 33
        ------------------------------------------------------------
        GroundStartPos = GroundStartPos - (dt * 333)
        if(GroundStartPos < -300)
        then
            GroundStartPos = GroundStartPos + 192
        end
    
        for k,v in pairs(Grounds) do
            local x = GroundStartPos + k * 96
            v.x = x
            v.y = GroundY
        end
        ------------------------------------------------------------
        animation.currentTime = animation.currentTime + dt
        if animation.currentTime >= animation.duration then
            animation.currentTime = animation.currentTime - animation.duration
        end
        ------------------------------------------------------------
        SpawnStopwatch = SpawnStopwatch + dt
        if(SpawnStopwatch > SpawnTimer)
        then
            SpawnStopwatch = 0
            CreateSpike()
        end
        
        for k,v in pairs(Spikes)
        do
            v.x = v.x - (dt * 333)

            IsCollided(100, 310 + ExtraY, v.x, v.y)
        end
        ------------------------------------------------------------
        if love.keyboard.isDown("w") and (HeldJumpingButton < MaxHeld)
        then
            ExtraY = ExtraY - 10
            HeldJumpingButton = HeldJumpingButton + dt
        elseif(ExtraY < 0) 
        then
            fallingStopwatch = fallingStopwatch + dt
            ExtraY = ExtraY + (fallingStopwatch * 25) - 5
            if(ExtraY > 0)
            then
                fallingStopwatch = 0
                ExtraY = 0
                HeldJumpingButton = 0
            end
        end
        ------------------------------------------------------------
    end
end

function ResetGame()
    
    Spikes = {}
    SpawnStopwatch = 0
    fallingStopwatch = 0
    HeldJumpingButton = 0
    ExtraY = 0
    Score = 0
    GameOver = false
    GameisActive = true
end

--Creates an animation table
function NewAnimation(image, width, height, duration)
    local animation = {}
    animation.spriteSheet = image;
    animation.quads = {};

    for y = 0, image:getHeight() - height, height do
        for x = 0, image:getWidth() - width, width do
            table.insert(animation.quads, love.graphics.newQuad(
                x, y, width, height, image:getDimensions()))
        end
    end

    animation.duration = duration or 1
    animation.currentTime = 0

    return animation
end

function CreateSpike()
      
    local temp =
    {
        x = 1000,
        y = 380
    }
    table.insert(Spikes, temp)
end

function IsCollided(playerPosX, playerPosY, obstaclePosX, obstaclePosY)
      
    local Px = playerPosX - 11 * 2   --player left most position
    local Py = playerPosY - 15 * 2 *1.5--player bottom position
    local PLx = 22 * 4 --player X length
    local PLy = 22 * 4 *1.5--player Y length

    local Ox = obstaclePosX - 8 --player left most position
    local Oy = obstaclePosY + 1 --player bottom position
    local OLx = 15 --player X length
    local OLy = 7  --player Y length

    if (Px + PLx >= Ox) and
       (Px <= Ox + OLx) and
       (Py + PLy >= Oy) and
       (Py <= Oy + OLy)
    then
        Died()
    end
end

function Died()

    GameisActive = false
    GameOver = true
end
--Updates the score UI
function UpdateScoreUI()

    local font = love.graphics.getFont()
    ---@diagnostic disable-next-line: param-type-mismatch
    KillCountText = love.graphics.newText(font, {{0, 1, 0}, "Score: ", {1, 0.5, 1}, Score})
end

--Creates a random number
function RandNumber()

    SeedCreatingValue = SeedCreatingValue + 1
    math.randomseed(SeedCreatingValue)

    return math.random()
end

--Checks if given thing exists
function Exists(a)
    return a ~= nil
end