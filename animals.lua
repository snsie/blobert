local animals = {}

function animals:init()
    self.list = {}
    self.animalTypes = {
        {
            name = "rabbit",
            size = 48,
            speed = 50,
            color = {0.8, 0.6, 0.4, 1.0},
            behavior = "flee",
            sprite = "rabbit"
        },
        {
            name = "bird",
            size = 42,
            speed = 80,
            color = {0.2, 0.8, 0.2, 1.0},
            behavior = "fly",
            sprite = "bird"
        },
        {
            name = "mouse",
            size = 36,
            speed = 60,
            color = {0.6, 0.6, 0.6, 1.0},
            behavior = "wander",
            sprite = "mouse"
        },
        {
            name = "squirrel",
            size = 60,
            speed = 70,
            color = {0.8, 0.4, 0.2, 1.0},
            behavior = "flee",
            sprite = "squirrel"
        },
        {
            name = "butterfly",
            size = 30,
            speed = 40,
            color = {1.0, 0.8, 0.2, 1.0},
            behavior = "fly",
            sprite = "butterfly"
        },
        {
            name = "fox",
            size = 54,
            speed = 65,
            color = {1.0, 0.4, 0.0, 1.0},
            behavior = "flee",
            sprite = "fox"
        },
        {
            name = "deer",
            size = 72,
            speed = 55,
            color = {0.7, 0.5, 0.3, 1.0},
            behavior = "flee",
            sprite = "deer"
        },
        {
            name = "owl",
            size = 42,
            speed = 45,
            color = {0.4, 0.3, 0.2, 1.0},
            behavior = "fly",
            sprite = "owl"
        }
    }
    
    -- Spawn initial animals
    self:spawnAnimals(50)
end

function animals:spawnAnimals(count)
    for i = 1, count do
        self:spawnRandomAnimal()
    end
end

function animals:spawnRandomAnimal()
    local animalType = self.animalTypes[love.math.random(#self.animalTypes)]
    -- Add 20% size variation
    local sizeVariation = love.math.random(0.8, 1.2)
    local animal = {
        x = love.math.random(-800, 800),
        y = love.math.random(-600, 600),
        vx = 0,
        vy = 0,
        size = animalType.size * sizeVariation,
        speed = animalType.speed,
        color = animalType.color,
        behavior = animalType.behavior,
        name = animalType.name,
        sprite = animalType.sprite,
        direction = love.math.random() * 2 * math.pi,
        changeDirectionTimer = 0,
        fleeTimer = 0
    }
    
    table.insert(self.list, animal)
end

function animals:update(dt)
    for _, animal in ipairs(self.list) do
        self:updateAnimal(animal, dt)
    end
    
    -- Spawn new animals at 1 per second
    self.spawnTimer = (self.spawnTimer or 0) + dt
    if self.spawnTimer >= 1.0 and #self.list < 120 then
        self:spawnRandomAnimal()
        self.spawnTimer = 0
    end
end

function animals:updateAnimal(animal, dt)
    local playerDistance = math.sqrt((player.x - animal.x)^2 + (player.y - animal.y)^2)
    
    if animal.behavior == "flee" then
        -- Flee from player when close
        if playerDistance < 150 then
            animal.fleeTimer = 2
            local angle = math.atan2(animal.y - player.y, animal.x - player.x)
            animal.direction = angle
        end
    elseif animal.behavior == "fly" then
        -- Fly in patterns, avoid player
        if playerDistance < 100 then
            local angle = math.atan2(animal.y - player.y, animal.x - player.x)
            animal.direction = angle
        else
            animal.changeDirectionTimer = animal.changeDirectionTimer - dt
            if animal.changeDirectionTimer <= 0 then
                animal.direction = animal.direction + love.math.random(-0.5, 0.5)
                animal.changeDirectionTimer = love.math.random(1, 3)
            end
        end
    elseif animal.behavior == "wander" then
        -- Simple wandering behavior
        animal.changeDirectionTimer = animal.changeDirectionTimer - dt
        if animal.changeDirectionTimer <= 0 then
            animal.direction = love.math.random() * 2 * math.pi
            animal.changeDirectionTimer = love.math.random(2, 5)
        end
    end
    
    -- Update flee timer
    if animal.fleeTimer > 0 then
        animal.fleeTimer = animal.fleeTimer - dt
    end
    
    -- Apply movement
    local targetSpeed = animal.speed
    if animal.fleeTimer > 0 then
        targetSpeed = animal.speed * 1.5
    end
    
    animal.vx = math.cos(animal.direction) * targetSpeed
    animal.vy = math.sin(animal.direction) * targetSpeed
    
    animal.x = animal.x + animal.vx * dt
    animal.y = animal.y + animal.vy * dt
    
    -- Keep animals within bounds
    local bounds = 1000
    if animal.x < -bounds then animal.x = -bounds end
    if animal.x > bounds then animal.x = bounds end
    if animal.y < -bounds then animal.y = -bounds end
    if animal.y > bounds then animal.y = bounds end
end

function animals:draw()
    for _, animal in ipairs(self.list) do
        love.graphics.setColor(animal.color)
        
        if animal.sprite == "butterfly" then
            -- Draw butterfly with flapping wings
            love.graphics.push()
            love.graphics.translate(animal.x, animal.y)
            love.graphics.rotate(love.timer.getTime() * 3)
            love.graphics.circle("fill", -animal.size/4, 0, animal.size / 4)
            love.graphics.circle("fill", animal.size/4, 0, animal.size / 4)
            love.graphics.pop()
            
        elseif animal.sprite == "bird" then
            -- Draw bird with wings
            love.graphics.circle("fill", animal.x, animal.y, animal.size / 3)
            love.graphics.setColor(0.1, 0.5, 0.1, 1.0)
            love.graphics.circle("fill", animal.x - animal.size/4, animal.y - animal.size/4, animal.size / 6)
            love.graphics.circle("fill", animal.x + animal.size/4, animal.y - animal.size/4, animal.size / 6)
            
        elseif animal.sprite == "owl" then
            -- Draw owl with big eyes
            love.graphics.circle("fill", animal.x, animal.y, animal.size / 2)
            love.graphics.setColor(1, 1, 1, 1)
            love.graphics.circle("fill", animal.x - animal.size/4, animal.y - animal.size/4, animal.size / 6)
            love.graphics.circle("fill", animal.x + animal.size/4, animal.y - animal.size/4, animal.size / 6)
            love.graphics.setColor(0, 0, 0, 1)
            love.graphics.circle("fill", animal.x - animal.size/4, animal.y - animal.size/4, animal.size / 12)
            love.graphics.circle("fill", animal.x + animal.size/4, animal.y - animal.size/4, animal.size / 12)
            
        elseif animal.sprite == "rabbit" then
            -- Draw rabbit with long ears
            love.graphics.circle("fill", animal.x, animal.y, animal.size / 2)
            love.graphics.setColor(0.9, 0.7, 0.5, 1.0)
            love.graphics.circle("fill", animal.x, animal.y - animal.size/2, animal.size / 4)
            love.graphics.circle("fill", animal.x, animal.y - animal.size/2, animal.size / 4)
            
        elseif animal.sprite == "squirrel" then
            -- Draw squirrel with bushy tail
            love.graphics.circle("fill", animal.x, animal.y, animal.size / 2)
            love.graphics.setColor(0.6, 0.3, 0.1, 1.0)
            love.graphics.circle("fill", animal.x + animal.size/3, animal.y, animal.size / 3)
            
        elseif animal.sprite == "fox" then
            -- Draw fox with pointy ears
            love.graphics.circle("fill", animal.x, animal.y, animal.size / 2)
            love.graphics.setColor(0.8, 0.3, 0.0, 1.0)
            love.graphics.circle("fill", animal.x - animal.size/4, animal.y - animal.size/2, animal.size / 6)
            love.graphics.circle("fill", animal.x + animal.size/4, animal.y - animal.size/2, animal.size / 6)
            
        elseif animal.sprite == "deer" then
            -- Draw deer with antlers
            love.graphics.circle("fill", animal.x, animal.y, animal.size / 2)
            love.graphics.setColor(0.5, 0.3, 0.1, 1.0)
            love.graphics.rectangle("fill", animal.x - animal.size/6, animal.y - animal.size/2, animal.size/3, animal.size/3)
            love.graphics.rectangle("fill", animal.x - animal.size/6, animal.y - animal.size/2, animal.size/3, animal.size/3)
            
        elseif animal.sprite == "mouse" then
            -- Draw mouse with small ears
            love.graphics.circle("fill", animal.x, animal.y, animal.size / 2)
            love.graphics.setColor(0.7, 0.7, 0.7, 1.0)
            love.graphics.circle("fill", animal.x - animal.size/4, animal.y - animal.size/4, animal.size / 8)
            love.graphics.circle("fill", animal.x + animal.size/4, animal.y - animal.size/4, animal.size / 8)
        else
            -- Default animal
            love.graphics.circle("fill", animal.x, animal.y, animal.size / 2)
        end
        
        -- Add eyes for all animals
        love.graphics.setColor(1, 1, 1, 1)
        love.graphics.circle("fill", animal.x - animal.size/6, animal.y - animal.size/6, animal.size / 12)
        love.graphics.circle("fill", animal.x + animal.size/6, animal.y - animal.size/6, animal.size / 12)
        love.graphics.setColor(0, 0, 0, 1)
        love.graphics.circle("fill", animal.x - animal.size/6, animal.y - animal.size/6, animal.size / 24)
        love.graphics.circle("fill", animal.x + animal.size/6, animal.y - animal.size/6, animal.size / 24)
    end
    
    love.graphics.setColor(1, 1, 1, 1)
end

return animals
