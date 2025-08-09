function love.load()
    -- Initialize game state
    game = {
        state = "playing",
        camera = {
            x = 0,
            y = 0,
            zoom = 1
        },
        gameOver = false,
        gameOverReason = ""
    }
    
    -- Load all game modules
    player = require("player")
    world = require("world")
    animals = require("animals")
    particles = require("particles")
    ui = require("ui")
    
    -- Initialize modules
    player:init()
    world:init()
    animals:init()
    particles:init()
    ui:init()
end

function love.update(dt)
    -- Check for game over
    if game.gameOver then
        return
    end
    
    if game.state == "playing" then
        player:update(dt)
        world:update(dt)
        animals:update(dt)
        particles:update(dt)
        ui:update(dt)
    end
end

function love.draw()
    love.graphics.push()
    
    -- Apply camera transform
    love.graphics.translate(love.graphics.getWidth() / 2, love.graphics.getHeight() / 2)
    love.graphics.scale(game.camera.zoom, game.camera.zoom)
    love.graphics.translate(-game.camera.x, -game.camera.y)
    
    -- Draw game world
    world:draw()
    animals:draw()
    player:draw()
    particles:draw()
    
    love.graphics.pop()
    
    -- Draw UI (not affected by camera)
    ui:draw()
    
    -- Draw game over screen
    if game.gameOver then
        love.graphics.setColor(0, 0, 0, 0.8)
        love.graphics.rectangle("fill", 0, 0, love.graphics.getWidth(), love.graphics.getHeight())
        
        love.graphics.setColor(1, 0, 0, 1)
        love.graphics.setFont(love.graphics.newFont(48))
        love.graphics.printf("GAME OVER", 0, love.graphics.getHeight() / 2 - 100, love.graphics.getWidth(), "center")
        
        love.graphics.setColor(1, 1, 1, 1)
        love.graphics.setFont(love.graphics.newFont(24))
        love.graphics.printf(game.gameOverReason, 0, love.graphics.getHeight() / 2 - 50, love.graphics.getWidth(), "center")
        
        love.graphics.setFont(love.graphics.newFont(16))
        love.graphics.printf("Press ESC to quit", 0, love.graphics.getHeight() / 2 + 50, love.graphics.getWidth(), "center")
    end
end

function love.keypressed(key)
    if key == "escape" then
        love.event.quit()
    end
end
