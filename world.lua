local world = {}

function world:init()
    self.grassPatches = {}
    self.trees = {}
    self.flowers = {}
    self.rocks = {}
    
    -- Generate grass patches
    for i = 1, 100 do
        table.insert(self.grassPatches, {
            x = love.math.random(-2000, 2000),
            y = love.math.random(-2000, 2000),
            size = love.math.random(20, 60)
        })
    end
    
    -- Generate trees
    for i = 1, 30 do
        table.insert(self.trees, {
            x = love.math.random(-2000, 2000),
            y = love.math.random(-2000, 2000),
            size = love.math.random(30, 80),
            type = love.math.random(1, 3)
        })
    end
    
    -- Generate flowers
    for i = 1, 50 do
        table.insert(self.flowers, {
            x = love.math.random(-2000, 2000),
            y = love.math.random(-2000, 2000),
            color = {
                love.math.random(0.8, 1.0),
                love.math.random(0.2, 0.8),
                love.math.random(0.2, 0.8),
                1.0
            },
            size = love.math.random(5, 15)
        })
    end
    
    -- Generate rocks
    for i = 1, 20 do
        table.insert(self.rocks, {
            x = love.math.random(-2000, 2000),
            y = love.math.random(-2000, 2000),
            size = love.math.random(10, 30)
        })
    end
end

function world:update(dt)
    -- Animate grass swaying
    for _, grass in ipairs(self.grassPatches) do
        grass.sway = (grass.sway or 0) + dt * 2
    end
end

function world:draw()
    -- Draw background gradient
    love.graphics.setColor(0.4, 0.8, 0.4, 1.0)
    love.graphics.rectangle("fill", -3000, -3000, 6000, 6000)
    
    -- Draw grass patches
    love.graphics.setColor(0.3, 0.7, 0.3, 1.0)
    for _, grass in ipairs(self.grassPatches) do
        love.graphics.push()
        love.graphics.translate(grass.x, grass.y)
        love.graphics.rotate(math.sin(grass.sway or 0) * 0.1)
        
        -- Draw grass blades
        for i = 1, 5 do
            local angle = (i - 1) * (math.pi / 3)
            local x = math.cos(angle) * grass.size * 0.3
            local y = math.sin(angle) * grass.size * 0.3
            love.graphics.rectangle("fill", x - 1, y - grass.size/2, 2, grass.size)
        end
        
        love.graphics.pop()
    end
    
    -- Draw rocks
    love.graphics.setColor(0.5, 0.5, 0.5, 1.0)
    for _, rock in ipairs(self.rocks) do
        love.graphics.circle("fill", rock.x, rock.y, rock.size)
        love.graphics.setColor(0.3, 0.3, 0.3, 1.0)
        love.graphics.circle("line", rock.x, rock.y, rock.size)
        love.graphics.setColor(0.5, 0.5, 0.5, 1.0)
    end
    
    -- Draw flowers
    for _, flower in ipairs(self.flowers) do
        love.graphics.setColor(flower.color)
        love.graphics.circle("fill", flower.x, flower.y, flower.size)
        love.graphics.setColor(0.2, 0.8, 0.2, 1.0)
        love.graphics.rectangle("fill", flower.x - 1, flower.y, 2, flower.size * 2)
    end
    
    -- Draw trees
    for _, tree in ipairs(self.trees) do
        -- Tree trunk
        love.graphics.setColor(0.6, 0.4, 0.2, 1.0)
        love.graphics.rectangle("fill", tree.x - tree.size/6, tree.y - tree.size/2, tree.size/3, tree.size)
        
        -- Tree leaves
        love.graphics.setColor(0.2, 0.6, 0.2, 1.0)
        love.graphics.circle("fill", tree.x, tree.y - tree.size/3, tree.size/2)
        
        -- Add some variation
        if tree.type == 2 then
            love.graphics.setColor(0.1, 0.5, 0.1, 1.0)
            love.graphics.circle("fill", tree.x - tree.size/4, tree.y - tree.size/3, tree.size/3)
        elseif tree.type == 3 then
            love.graphics.setColor(0.3, 0.7, 0.3, 1.0)
            love.graphics.circle("fill", tree.x + tree.size/4, tree.y - tree.size/3, tree.size/3)
        end
    end
    
    -- Reset color
    love.graphics.setColor(1, 1, 1, 1)
end

return world
