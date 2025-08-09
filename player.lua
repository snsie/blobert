local player = {}

function player:init()
    self.x = 100
    self.y = 100
    self.size = 50
    self.radius = self.size / 2
    self.speed = 40000
    self.rotation = 0
    self.rotationSpeed = 0
    self.absorbedItems = {}
    self.totalSize = self.size
    
    -- Movement
    self.vx = 0
    self.vy = 0
    self.friction = 0.8
    
    -- Visual
    self.color = {0.2, 0.6, 1.0, 1.0}
    self.trail = {}
    self.maxTrailLength = 10
end

function player:update(dt)
    -- Handle input
    local dx, dy = 0, 0
    
    if love.keyboard.isDown("w") or love.keyboard.isDown("up") then
        dy = dy - 1
    end
    if love.keyboard.isDown("s") or love.keyboard.isDown("down") then
        dy = dy + 1
    end
    if love.keyboard.isDown("a") or love.keyboard.isDown("left") then
        dx = dx - 1
    end
    if love.keyboard.isDown("d") or love.keyboard.isDown("right") then
        dx = dx + 1
    end
    
    -- Debug: Print input values
    if dx ~= 0 or dy ~= 0 then
        print("Input detected: dx=" .. dx .. ", dy=" .. dy)
    end
    
    -- Normalize diagonal movement
    if dx ~= 0 and dy ~= 0 then
        dx = dx * 0.707
        dy = dy * 0.707
    end
    
    -- Apply movement
    self.vx = self.vx + dx * self.speed * dt
    self.vy = self.vy + dy * self.speed * dt
    
    -- Apply friction
    self.vx = self.vx * self.friction
    self.vy = self.vy * self.friction
    
    -- Update position
    self.x = self.x + self.vx * dt
    self.y = self.y + self.vy * dt
    
    -- Update rotation based on movement
    if math.abs(self.vx) > 0.1 or math.abs(self.vy) > 0.1 then
        self.rotationSpeed = math.sqrt(self.vx * self.vx + self.vy * self.vy) * 0.01
        self.rotation = self.rotation + self.rotationSpeed
    else
        self.rotationSpeed = self.rotationSpeed * 0.9
        self.rotation = self.rotation + self.rotationSpeed
    end
    
    -- Update trail
    table.insert(self.trail, {x = self.x, y = self.y, size = self.totalSize})
    if #self.trail > self.maxTrailLength then
        table.remove(self.trail, 1)
    end
    
    -- Update camera to follow player
    game.camera.x = self.x
    game.camera.y = self.y
    
    -- Check for animal absorption
    self:checkAbsorption()
    
    -- Check for tree collisions
    self:checkTreeCollisions()
end

function player:checkAbsorption()
    print("Checking absorption - Player size: " .. math.floor(self.totalSize) .. ", Animals: " .. #animals.list)
    
    for i = #animals.list, 1, -1 do
        local animal = animals.list[i]
        local distance = math.sqrt((self.x - animal.x)^2 + (self.y - animal.y)^2)
        local collisionDistance = self.totalSize / 2 + animal.size / 2
        
        -- Debug: Print collision info for nearby animals
        if distance < 200 then
            print("Animal " .. i .. " (" .. animal.name .. ") - Distance: " .. math.floor(distance) .. ", Collision threshold: " .. math.floor(collisionDistance) .. ", Animal size: " .. math.floor(animal.size) .. ", Player size: " .. math.floor(self.totalSize))
        end
        
        if distance < collisionDistance then
            print("COLLISION DETECTED! Animal: " .. animal.name .. ", Size: " .. math.floor(animal.size) .. ", Player: " .. math.floor(self.totalSize))
            
            -- Check if animal is smaller than or equal to player
            if animal.size <= self.totalSize then
                print("ABSORBING ANIMAL! Distance: " .. distance .. ", Threshold: " .. collisionDistance)
                
                -- Create absorption effect BEFORE removing the animal
                particles:createAbsorptionEffect(animal.x, animal.y, animal.color)
                
                -- Absorb the animal
                self:absorbAnimal(animal)
                
                -- Remove the animal from the list
                table.remove(animals.list, i)
                
                -- Add a small delay to prevent multiple absorptions
                break
            else
                print("Animal too big! Cannot absorb " .. animal.name .. " (size: " .. animal.size .. ", player: " .. self.totalSize .. ")")
                -- Push player away from big animal
                local angle = math.atan2(self.y - animal.y, self.x - animal.x)
                self.x = animal.x + math.cos(angle) * (collisionDistance + 20)
                self.y = animal.y + math.sin(angle) * (collisionDistance + 20)
                break
            end
        end
    end
end

function player:absorbAnimal(animal)
    -- Increase player size
    self.totalSize = self.totalSize + animal.size * 0.3
    self.radius = self.totalSize / 2
    
    -- Check for game over (player too big for screen)
    local screenWidth = love.graphics.getWidth()
    local screenHeight = love.graphics.getHeight()
    if self.totalSize > screenWidth or self.totalSize > screenHeight then
        game.gameOver = true
        game.gameOverReason = "You got too big for the screen!"
        print("GAME OVER! Player size: " .. self.totalSize .. ", Screen: " .. screenWidth .. "x" .. screenHeight)
        return
    end
    
    -- Add to absorbed items
    table.insert(self.absorbedItems, {
        type = "animal",
        size = animal.size,
        color = animal.color
    })
    
    -- Add score based on animal size
    local scorePoints = animal.size * 10
    ui:addScore(scorePoints)
    
    -- Update UI
    ui:updateScore(#self.absorbedItems)
    
    print("Absorbed " .. animal.name .. "! +" .. scorePoints .. " points")
end

function player:checkTreeCollisions()
    for i = #world.trees, 1, -1 do
        local tree = world.trees[i]
        local distance = math.sqrt((self.x - tree.x)^2 + (self.y - tree.y)^2)
        local collisionDistance = self.totalSize / 2 + tree.size / 2
        
        if distance < collisionDistance then
            -- Hit a tree - get smaller
            self:shrinkFromTree()
            
            -- Create collision effect
            particles:createTreeCollisionEffect(tree.x, tree.y)
            
            -- Create threatening message popup
            ui:createTreeThreatPopup(tree.x, tree.y)
            
            -- Remove the tree
            table.remove(world.trees, i)
            
            -- Push player away from tree location
            local angle = math.atan2(self.y - tree.y, self.x - tree.x)
            self.x = tree.x + math.cos(angle) * (collisionDistance + 10)
            self.y = tree.y + math.sin(angle) * (collisionDistance + 10)
            
            print("Tree destroyed! Player size reduced to " .. math.floor(self.totalSize))
            break
        end
    end
end

function player:shrinkFromTree()
    -- Reduce player size
    self.totalSize = math.max(20, self.totalSize - 5)
    self.radius = self.totalSize / 2
    
    -- Remove some absorbed items if any
    if #self.absorbedItems > 0 then
        table.remove(self.absorbedItems, #self.absorbedItems)
    end
    
    -- Update UI
    ui:updateScore(#self.absorbedItems)
    
    print("Hit tree! Size reduced to " .. math.floor(self.totalSize))
end

function player:draw()
    -- Debug: Draw absorption radius
    love.graphics.setColor(1, 0, 0, 0.3)
    love.graphics.circle("line", self.x, self.y, self.totalSize / 2)
    
    -- Draw trail
    for i, trailPoint in ipairs(self.trail) do
        local alpha = i / #self.trail * 0.3
        love.graphics.setColor(0.2, 0.8, 0.3, alpha)
        love.graphics.circle("fill", trailPoint.x, trailPoint.y, trailPoint.size / 2)
    end
    
    -- Draw player blob monster
    love.graphics.push()
    love.graphics.translate(self.x, self.y)
    love.graphics.rotate(self.rotation)
    
    -- Main blob body (irregular shape)
    love.graphics.setColor(0.3, 0.8, 0.3, 1.0)
    love.graphics.circle("fill", 0, 0, self.radius)
    
    -- Add darker green shading
    love.graphics.setColor(0.2, 0.6, 0.2, 0.8)
    love.graphics.circle("fill", -self.radius * 0.3, -self.radius * 0.2, self.radius * 0.4)
    
    -- Add lumpy texture spots
    love.graphics.setColor(0.1, 0.5, 0.1, 0.9)
    for i = 1, 8 do
        local angle = (i - 1) * (2 * math.pi / 8)
        local spotX = math.cos(angle) * self.radius * 0.7
        local spotY = math.sin(angle) * self.radius * 0.7
        love.graphics.circle("fill", spotX, spotY, self.radius * 0.15)
    end
    
    -- Draw sad eyes
    love.graphics.setColor(0.1, 0.1, 0.1, 1.0)
    love.graphics.circle("fill", -self.radius * 0.3, -self.radius * 0.4, self.radius * 0.12)
    love.graphics.circle("fill", self.radius * 0.3, -self.radius * 0.4, self.radius * 0.12)
    
    -- Draw wide mouth with teeth
    love.graphics.setColor(0.6, 0.2, 0.2, 1.0)
    love.graphics.rectangle("fill", -self.radius * 0.6, self.radius * 0.2, self.radius * 1.2, self.radius * 0.3)
    
    -- Draw teeth
    love.graphics.setColor(0.9, 0.9, 0.8, 1.0)
    for i = 1, 8 do
        local toothX = -self.radius * 0.5 + (i - 1) * self.radius * 0.15
        local toothY = self.radius * 0.25
        love.graphics.rectangle("fill", toothX, toothY, self.radius * 0.1, self.radius * 0.15)
    end
    
    -- Draw dripping liquid
    love.graphics.setColor(0.6, 0.2, 0.2, 1.0)
    love.graphics.circle("fill", -self.radius * 0.4, self.radius * 0.5, self.radius * 0.08)
    love.graphics.circle("fill", self.radius * 0.4, self.radius * 0.5, self.radius * 0.08)
    love.graphics.circle("fill", -self.radius * 0.4, self.radius * 0.7, self.radius * 0.06)
    love.graphics.circle("fill", self.radius * 0.4, self.radius * 0.7, self.radius * 0.06)
    
    -- Draw absorbed items as smaller blobs around the monster
    for i, item in ipairs(self.absorbedItems) do
        local angle = (i - 1) * (2 * math.pi / #self.absorbedItems)
        local offsetX = math.cos(angle) * (self.radius * 1.2)
        local offsetY = math.sin(angle) * (self.radius * 1.2)
        
        -- Draw absorbed items as smaller green blobs
        love.graphics.setColor(0.4, 0.7, 0.4, 0.8)
        love.graphics.circle("fill", offsetX, offsetY, item.size / 2)
        love.graphics.setColor(0.3, 0.6, 0.3, 0.9)
        love.graphics.circle("fill", offsetX - item.size * 0.2, offsetY - item.size * 0.2, item.size * 0.3)
    end
    
    love.graphics.pop()
    
    -- Reset color
    love.graphics.setColor(1, 1, 1, 1)
end

return player
