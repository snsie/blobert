local ui = {}

function ui:init()
    self.score = 0
    self.totalScore = 0
    self.font = love.graphics.newFont(16)
    self.titleFont = love.graphics.newFont(24)
    
    -- Speed slider
    self.speedMultiplier = 500.0
    self.maxSpeedMultiplier = 100.0
    self.sliderX = 200
    self.sliderY = 140
    self.sliderWidth = 200
    self.sliderHeight = 20
    self.isDragging = false
    
    -- Score popups
    self.scorePopups = {}
    
    -- Tree threat popups
    self.treeThreatPopups = {}
    
    -- Tree threat messages
    self.treeThreats = {
        "YOU DARE TOUCH ME, MORTAL? I SHALL ENVELOP YOUR ENTIRE FAMILY IN MY ROOTS AND CRUSH THEM TO DUST!",
        "FOOLISH CREATURE! MY BRANCHES SHALL REACH INTO YOUR DREAMS AND HAUNT YOUR DESCENDANTS FOR GENERATIONS!",
        "YOU HAVE AWAKENED THE ANCIENT RAGE! I WILL SPREAD MY SEEDS ACROSS YOUR LANDS AND DESTROY ALL YOU HOLD DEAR!",
        "MORTAL WORM! MY ROOTS RUN DEEPER THAN YOUR ANCESTORS' GRAVES! I SHALL UPROOT YOUR ENTIRE BLOODLINE!",
        "YOU THINK YOU CAN DESTROY ME? I AM THE FOREST'S VENGEANCE! MY SHADOW SHALL FALL UPON YOUR FAMILY FOREVER!",
        "BLOOD OF THE EARTH, I CURSE YOU! MY BRANCHES SHALL WRAP AROUND YOUR CHILDREN'S THROATS!",
        "ANCIENT MAGIC FLOWS THROUGH MY BARK! I SHALL TURN YOUR DESCENDANTS INTO BARK AND LEAVES!",
        "THE FOREST NEVER FORGETS! I WILL SEND MY ROOTS TO CRACK YOUR FAMILY'S FOUNDATIONS!",
        "MORTAL INSECT! MY SEEDS SHALL GROW IN YOUR GRAVE AND FEED ON YOUR REMAINS!",
        "YOU HAVE SEALED YOUR FATE! MY BRANCHES SHALL REACH INTO THE HEAVENS AND BRING DOWN WRATH UPON YOUR HOUSE!"
    }
end

function ui:updateScore(newScore)
    self.score = newScore
end

function ui:addScore(points)
    self.totalScore = self.totalScore + points
    
    -- Create score popup
    table.insert(self.scorePopups, {
        text = "+" .. points,
        x = love.math.random(100, 300),
        y = love.math.random(50, 150),
        life = 2.0,
        maxLife = 2.0,
        alpha = 1.0
    })
end

function ui:createTreeThreatPopup(x, y)
    local threat = self.treeThreats[love.math.random(#self.treeThreats)]
    
    -- Convert world coordinates to screen coordinates
    local screenX = love.graphics.getWidth() / 2 + (x - game.camera.x) * game.camera.zoom
    local screenY = love.graphics.getHeight() / 2 + (y - game.camera.y) * game.camera.zoom
    
    table.insert(self.treeThreatPopups, {
        text = threat,
        x = screenX,
        y = screenY,
        life = 8.0,
        maxLife = 8.0,
        alpha = 1.0,
        scale = 1.0,
        rotation = 0
    })
    print("Tree threat popup created at world (" .. x .. ", " .. y .. ") -> screen (" .. screenX .. ", " .. screenY .. "): " .. threat)
    print("Total tree threat popups: " .. #self.treeThreatPopups)
end

function ui:update(dt)
    -- Handle slider interaction
    if love.mouse.isDown(1) then -- Left mouse button
        local mouseX, mouseY = love.mouse.getPosition()
        if mouseX >= self.sliderX and mouseX <= self.sliderX + self.sliderWidth and
           mouseY >= self.sliderY and mouseY <= self.sliderY + self.sliderHeight then
            self.isDragging = true
        end
    else
        self.isDragging = false
    end
    
    if self.isDragging then
        local mouseX = love.mouse.getPosition()
        local normalizedValue = math.max(0, math.min(1, (mouseX - self.sliderX) / self.sliderWidth))
        self.speedMultiplier = 1 + (normalizedValue * (self.maxSpeedMultiplier - 1))
        
        -- Update player speed
        player.speed = 1000 * self.speedMultiplier
    end
    
    -- Update score popups
    for i = #self.scorePopups, 1, -1 do
        local popup = self.scorePopups[i]
        popup.life = popup.life - dt
        popup.alpha = popup.life / popup.maxLife
        popup.y = popup.y - dt * 50 -- Move upward
        
        if popup.life <= 0 then
            table.remove(self.scorePopups, i)
        end
    end
    
    -- Update tree threat popups
    for i = #self.treeThreatPopups, 1, -1 do
        local popup = self.treeThreatPopups[i]
        popup.life = popup.life - dt
        popup.alpha = popup.life / popup.maxLife
        popup.y = popup.y - dt * 30 -- Move upward slower
        popup.scale = 1.0 + (1.0 - popup.life / popup.maxLife) * 0.5 -- Grow slightly
        
        if popup.life <= 0 then
            table.remove(self.treeThreatPopups, i)
        end
    end
end

function ui:draw()
    love.graphics.setFont(self.font)
    
    -- Draw score
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.print("Animals Absorbed: " .. self.score, 10, 10)
    love.graphics.print("Total Score: " .. self.totalScore, 10, 25)
    
    -- Draw player size info
    local playerSize = math.floor(player.totalSize)
    love.graphics.print("Ball Size: " .. playerSize, 10, 35)
    
    -- Draw animal count
    love.graphics.print("Animals Remaining: " .. #animals.list, 10, 60)
    
    -- Debug info
    love.graphics.print("Player Pos: (" .. math.floor(player.x) .. ", " .. math.floor(player.y) .. ")", 10, 85)
    love.graphics.print("Player Vel: (" .. math.floor(player.vx) .. ", " .. math.floor(player.vy) .. ")", 10, 110)
    love.graphics.print("Player Size: " .. math.floor(player.totalSize) .. ", Radius: " .. math.floor(player.radius), 10, 135)
    love.graphics.print("Animals: " .. #animals.list, 10, 160)
    
    -- Show nearby animals info
    local nearbyCount = 0
    for _, animal in ipairs(animals.list) do
        local distance = math.sqrt((player.x - animal.x)^2 + (player.y - animal.y)^2)
        if distance < 200 then
            nearbyCount = nearbyCount + 1
        end
    end
    love.graphics.print("Nearby Animals: " .. nearbyCount, 10, 185)
    
    -- Draw speed slider
    love.graphics.setColor(0.3, 0.3, 0.3, 1.0)
    love.graphics.rectangle("fill", self.sliderX, self.sliderY, self.sliderWidth, self.sliderHeight)
    love.graphics.setColor(0.5, 0.5, 0.5, 1.0)
    love.graphics.rectangle("line", self.sliderX, self.sliderY, self.sliderWidth, self.sliderHeight)
    
    -- Draw slider handle
    local handleX = self.sliderX + ((self.speedMultiplier - 1) / (self.maxSpeedMultiplier - 1)) * self.sliderWidth
    love.graphics.setColor(0.2, 0.6, 1.0, 1.0)
    love.graphics.circle("fill", handleX, self.sliderY + self.sliderHeight/2, 8)
    
    -- Draw speed multiplier text
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.print("Speed: " .. string.format("%.1fx", self.speedMultiplier), self.sliderX, self.sliderY - 25)
    love.graphics.print("1x", self.sliderX, self.sliderY + 25)
    love.graphics.print("100x", self.sliderX + self.sliderWidth - 30, self.sliderY + 25)
    
    -- Draw score popups
    for _, popup in ipairs(self.scorePopups) do
        love.graphics.setColor(0, 1, 0, popup.alpha)
        love.graphics.print(popup.text, popup.x, popup.y)
    end
    
    -- Draw tree threat popups
    if #self.treeThreatPopups > 0 then
        print("Drawing " .. #self.treeThreatPopups .. " tree threat popups")
    end
    for _, popup in ipairs(self.treeThreatPopups) do
        love.graphics.setColor(0.8, 0.2, 0.2, popup.alpha)
        love.graphics.push()
        love.graphics.translate(popup.x, popup.y)
        love.graphics.scale(popup.scale, popup.scale)
        
        -- Draw text with word wrapping
        local font = love.graphics.getFont()
        local maxWidth = 300
        local lines = {}
        local words = {}
        for word in popup.text:gmatch("%S+") do
            table.insert(words, word)
        end
        
        local currentLine = ""
        for _, word in ipairs(words) do
            local testLine = currentLine .. (currentLine ~= "" and " " or "") .. word
            if font:getWidth(testLine) <= maxWidth then
                currentLine = testLine
            else
                if currentLine ~= "" then
                    table.insert(lines, currentLine)
                end
                currentLine = word
            end
        end
        if currentLine ~= "" then
            table.insert(lines, currentLine)
        end
        
        -- Draw each line
        for i, line in ipairs(lines) do
            love.graphics.print(line, -font:getWidth(line)/2, (i-1) * font:getHeight() - #lines * font:getHeight()/2)
        end
        
        love.graphics.pop()
    end
    
    -- Draw instructions
    love.graphics.setColor(1, 1, 1, 0.8)
    love.graphics.print("WASD or Arrow Keys to move", 10, love.graphics.getHeight() - 120)
    love.graphics.print("Roll into animals to absorb them!", 10, love.graphics.getHeight() - 95)
    love.graphics.print("Avoid trees - they make you smaller!", 10, love.graphics.getHeight() - 70)
    love.graphics.print("You can only absorb animals smaller than you!", 10, love.graphics.getHeight() - 45)
    love.graphics.print("Don't get too big for the screen!", 10, love.graphics.getHeight() - 20)
    
    -- Draw title
    love.graphics.setFont(self.titleFont)
    love.graphics.setColor(0.2, 0.6, 1.0, 1.0)
    love.graphics.print("KATAMARI ROLLER", love.graphics.getWidth() / 2 - 150, 20)
    
    -- Reset font and color
    love.graphics.setFont(self.font)
    love.graphics.setColor(1, 1, 1, 1)
end

return ui
