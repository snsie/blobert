local particles = {}

function particles:init()
    self.list = {}
end

function particles:createAbsorptionEffect(x, y, color)
    for i = 1, 8 do
        local angle = (i - 1) * (2 * math.pi / 8)
        local speed = love.math.random(50, 150)
        
        table.insert(self.list, {
            x = x,
            y = y,
            vx = math.cos(angle) * speed,
            vy = math.sin(angle) * speed,
            life = 1.0,
            maxLife = 1.0,
            size = love.math.random(3, 8),
            color = color,
            type = "absorption"
        })
    end
end

function particles:createTrailEffect(x, y, color)
    for i = 1, 3 do
        table.insert(self.list, {
            x = x + love.math.random(-10, 10),
            y = y + love.math.random(-10, 10),
            vx = love.math.random(-20, 20),
            vy = love.math.random(-20, 20),
            life = 0.5,
            maxLife = 0.5,
            size = love.math.random(2, 5),
            color = color,
            type = "trail"
        })
    end
end

function particles:createTreeCollisionEffect(x, y)
    for i = 1, 12 do
        local angle = (i - 1) * (2 * math.pi / 12)
        local speed = love.math.random(30, 80)
        
        table.insert(self.list, {
            x = x,
            y = y,
            vx = math.cos(angle) * speed,
            vy = math.sin(angle) * speed,
            life = 1.5,
            maxLife = 1.5,
            size = love.math.random(4, 10),
            color = {0.6, 0.4, 0.2, 1.0},
            type = "tree_collision"
        })
    end
end

function particles:update(dt)
    for i = #self.list, 1, -1 do
        local particle = self.list[i]
        
        -- Update position
        particle.x = particle.x + particle.vx * dt
        particle.y = particle.y + particle.vy * dt
        
        -- Update life
        particle.life = particle.life - dt
        
        -- Apply gravity to absorption particles
        if particle.type == "absorption" then
            particle.vy = particle.vy + 100 * dt
        elseif particle.type == "tree_collision" then
            particle.vy = particle.vy + 50 * dt
        end
        
        -- Remove dead particles
        if particle.life <= 0 then
            table.remove(self.list, i)
        end
    end
end

function particles:draw()
    for _, particle in ipairs(self.list) do
        local alpha = particle.life / particle.maxLife
        local r, g, b = unpack(particle.color)
        
        love.graphics.setColor(r, g, b, alpha)
        
        if particle.type == "absorption" then
            -- Draw absorption particles as stars
            love.graphics.push()
            love.graphics.translate(particle.x, particle.y)
            love.graphics.rotate(love.timer.getTime() * 2)
            
            for i = 1, 4 do
                local angle = (i - 1) * (math.pi / 2)
                local x = math.cos(angle) * particle.size
                local y = math.sin(angle) * particle.size
                love.graphics.circle("fill", x, y, 1)
            end
            
            love.graphics.pop()
        elseif particle.type == "tree_collision" then
            -- Draw tree collision particles as wood chips
            love.graphics.circle("fill", particle.x, particle.y, particle.size)
        else
            -- Draw trail particles as circles
            love.graphics.circle("fill", particle.x, particle.y, particle.size)
        end
    end
    
    love.graphics.setColor(1, 1, 1, 1)
end

return particles
