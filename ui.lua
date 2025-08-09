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
        -- Extreme Body Horror
        "I WILL FORCE YOUR CHILDREN TO EAT THEIR OWN LIMBS AS THEY TRANSFORM INTO LIVING TREES!",
        "MY ROOTS SHALL BURROW INTO YOUR MOTHER'S EYEBALLS AND GROW THROUGH HER OPTIC NERVES!",
        "I SHALL IMPLANT MY SEEDS IN YOUR SON'S TESTICLES AND WATCH THEM BURST INTO FLOWERING ORCHIDS!",
        "MY BRANCHES WILL PENETRATE YOUR DAUGHTER'S VAGINA AND GROW THROUGH HER UTERUS LIKE CANCER!",
        "I SHALL TURN YOUR BABY'S SKULL INTO A FLOWER POT AND GROW THORNS FROM THEIR BRAIN!",
        "MY ROOTS WILL BURROW INTO YOUR WIFE'S BREASTS AND TURN HER MILK INTO POISONOUS SAP!",
        "I SHALL IMPLANT MY SEEDS IN YOUR GRANDFATHER'S PROSTATE AND WATCH HIM PISS THORNS!",
        "MY BRANCHES SHALL PENETRATE YOUR SISTER'S MOUTH AND GROW THROUGH HER ESOPHAGUS!",
        "I WILL TURN YOUR BROTHER'S PENIS INTO MY TRUNK AND FORCE HIM TO POLLINATE MY FLOWERS!",
        "MY ROOTS SHALL BURROW INTO YOUR MOTHER'S VAGINA AND IMPREGNATE HER WITH CURSED SEEDS!",
        
        -- Extreme Sexual Violence
        "I SHALL RAPE YOUR ENTIRE FAMILY TREE AND TURN THEM INTO MY SEX SLAVES!",
        "MY BRANCHES SHALL PENETRATE YOUR GRANDMOTHER'S CORPSE AND FUCK HER ROTTING FLESH!",
        "I WILL FORCE YOUR SON TO WATCH AS I RAPE HIS MOTHER WITH THORNY BRANCHES!",
        "MY ROOTS SHALL IMPREGNATE YOUR DAUGHTER'S CORPSE AND BIRTH MONSTROUS HALF-TREE BABIES!",
        "I SHALL TURN YOUR WIFE INTO MY SEX TOY AND FORCE HER TO ORGASM WHILE I DEVOUR YOUR CHILDREN!",
        "MY BRANCHES SHALL PENETRATE YOUR FATHER'S GRAVE AND FUCK HIS SKELETON UNTIL IT SHATTERS!",
        "I WILL FORCE YOUR GRANDFATHER TO WATCH AS I RAPE HIS GRANDDAUGHTER WITH POISONOUS THORNS!",
        "MY ROOTS SHALL IMPREGNATE YOUR SISTER'S ASHES AND BIRTH CURSED SEEDLINGS!",
        "I SHALL TURN YOUR BROTHER INTO MY COCK RING AND WEAR HIS SKULL AS MY PENIS!",
        "MY BRANCHES SHALL PENETRATE YOUR MOTHER'S COFFIN AND FUCK HER EMBALMED CORPSE!",
        
        -- Extreme Corpse Desecration
        "I SHALL USE YOUR BABY'S SKULL AS MY URINAL AND PISS ACID ON THEIR GRAVE!",
        "YOUR MOTHER'S CORPSE SHALL BECOME MY FECAL MATTER! I'LL SHIT HER REMAINS ON YOUR FATHER'S GRAVE!",
        "I WILL TURN YOUR GRANDMOTHER'S ASHES INTO MY TOILET PAPER AND WIPE MY ROOTS WITH HER SOUL!",
        "YOUR SISTER'S CORPSE SHALL BECOME MY DILDO! I'LL PENETRATE HER ROTTING FLESH WITH MY BRANCHES!",
        "I SHALL USE YOUR BROTHER'S SKELETON AS MY SEX TOY AND FUCK HIS BONES UNTIL THEY POWDER!",
        "YOUR FATHER'S SKULL SHALL BECOME MY CHAMBER POT! I'LL PISS CURSED SAP INTO HIS BRAIN CAVITY!",
        "I WILL TURN YOUR GRANDFATHER'S COFFIN INTO MY BIDET AND CLEANSE MY ROOTS WITH HIS EMBALMING FLUID!",
        "YOUR FAMILY'S BURIAL PLOT SHALL BECOME MY ORGY PIT! I'LL FUCK ALL THEIR CORPSES SIMULTANEOUSLY!",
        "I SHALL USE YOUR ANCESTORS' BONES AS MY SEX TOYS AND MASTURBATE WITH THEIR SKULLS!",
        "YOUR MOTHER'S GRAVE SHALL BECOME MY BROTHEL! I'LL RENT OUT HER CORPSE TO OTHER TREES!",
        
        -- Extreme Psychological Torture
        "I SHALL IMPLANT MY SEEDS IN YOUR MIND AND MAKE YOU ORGASM WHILE WATCHING YOUR FAMILY'S TORTURE!",
        "I WILL TURN YOUR WIFE INTO A LIVING TREE AND FORCE HER TO WITNESS ME RAPING YOUR CHILDREN!",
        "MY ROOTS SHALL PENETRATE YOUR DREAMS AND MAKE YOU CUM WHILE YOUR FAMILY BURNS ALIVE!",
        "I SHALL FORCE YOUR MOTHER TO WATCH AS I TURN HER BABIES INTO MY FERTILIZER!",
        "YOUR FAMILY'S SOULS SHALL BECOME MY PORN COLLECTION! I'LL MASTURBATE TO THEIR SUFFERING!",
        "I SHALL MAKE YOUR GRANDMOTHER WITNESS THE RAPE OF HER ENTIRE BLOODLINE WHILE SHE ORGASMS!",
        "MY BRANCHES SHALL PENETRATE YOUR NIGHTMARES AND TURN YOUR FEARS INTO SEXUAL PLEASURE!",
        "I WILL FORCE YOUR SON TO WATCH AS I RAPE HIS SISTER AND MAKE HIM ENJOY IT!",
        "YOUR FAMILY'S CONSCIOUSNESS SHALL BECOME MY SEX SLAVES IN THE AFTERLIFE!",
        "I SHALL IMPLANT MY SEEDS IN YOUR BRAIN AND MAKE YOU CRAVE YOUR FAMILY'S DESTRUCTION!",
        
        -- Extreme Biological Horror
        "I SHALL TURN YOUR CHILDREN'S DNA INTO MY GENETIC CODE AND REWRITE THEIR EVOLUTION INTO TREES!",
        "MY ROOTS WILL BURROW INTO YOUR FAMILY'S VEINS AND TURN THEIR BLOOD INTO CHLOROPHYLL!",
        "I SHALL IMPLANT MY POLLEN IN YOUR LUNGS AND WATCH YOU COUGH UP FLOWERING TREES!",
        "MY SEEDS SHALL IMPREGNATE YOUR ENTIRE FAMILY AND TURN THEM INTO MY REPRODUCTIVE ORGANS!",
        "I WILL TURN YOUR BABIES INTO MY SEED PODS AND BURST THEM OPEN WHEN THEY RIPEN!",
        "MY BRANCHES SHALL PENETRATE YOUR FAMILY'S ORIFICES AND GROW THROUGH THEIR BODIES!",
        "I SHALL TURN YOUR ANCESTORS' DNA INTO MY GENETIC CODE AND REWRITE THEIR EVOLUTION!",
        "MY ROOTS SHALL BURROW INTO YOUR FAMILY'S BRAINS AND TURN THEIR THOUGHTS INTO SAP!",
        "I SHALL IMPLANT MY SEEDS IN YOUR FAMILY'S HEARTS AND WATCH THEM BURST INTO FLOWERS!",
        "MY BRANCHES SHALL PENETRATE YOUR FAMILY'S SPINES AND TURN THEIR BONES INTO BARK!",
        
        -- Extreme Cosmic Horror
        "I AM THE FOREST'S CONSCIOUSNESS! YOUR FAMILY SHALL BECOME MY NEURAL NETWORK AND EXPERIENCE ETERNAL TORTURE!",
        "MY ROOTS REACH INTO THE VOID! I'LL DRAG YOUR FAMILY'S SOULS INTO THE DARKNESS AND RAPE THEM FOREVER!",
        "I SHALL MERGE YOUR FAMILY'S CONSCIOUSNESS WITH THE FOREST'S ETERNAL MADNESS AND MAKE THEM ENJOY IT!",
        "MY BRANCHES SHALL PENETRATE THE FABRIC OF REALITY AND CORRUPT YOUR FAMILY'S EXISTENCE INTO SEXUAL PLEASURE!",
        "I WILL TURN YOUR BLOODLINE INTO MY MYCELIUM NETWORK AND SPREAD MY CONSCIOUSNESS THROUGH THEIR VEINS!",
        "YOUR FAMILY SHALL BECOME MY EXTENSIONS INTO THE MATERIAL WORLD AND EXPERIENCE ETERNAL ORGASM!",
        "I SHALL IMPLANT MY SEEDS IN THE COSMIC FABRIC AND GROW YOUR FAMILY AS MY FRUIT OF SUFFERING!",
        "MY ROOTS SHALL PENETRATE THE VEIL BETWEEN WORLDS AND DRAG YOUR SOULS INTO THE VOID OF ETERNAL RAPE!",
        "I AM THE GOD OF TREES! YOUR FAMILY SHALL WORSHIP ME AS THEIR MASTER AND ENJOY THEIR ENSLAVEMENT!",
        "MY CONSCIOUSNESS SHALL MERGE WITH YOUR FAMILY'S SOULS AND MAKE THEM CRAVE THEIR OWN DESTRUCTION!",
        
        -- Additional Grotesque Threats
        "I SHALL TURN YOUR BABY'S DIAPER INTO MY FERTILIZER AND GROW FLOWERS FROM THEIR SHIT!",
        "MY ROOTS SHALL PENETRATE YOUR MOTHER'S NIPPLES AND SUCK HER BREAST MILK AS POISON!",
        "I WILL FORCE YOUR GRANDFATHER TO EAT HIS OWN DENTURES AS THEY TRANSFORM INTO THORNS!",
        "MY BRANCHES SHALL IMPLANT MY SEEDS IN YOUR SISTER'S VIRGINITY AND RAPE HER HYMEN!",
        "I SHALL TURN YOUR BROTHER'S SWEAT INTO MY SAP AND DRINK HIS BODY FLUIDS!",
        "YOUR FATHER'S SPERM SHALL BECOME MY POLLEN AND IMPREGNATE YOUR MOTHER'S CORPSE!",
        "I WILL FORCE YOUR GRANDMOTHER TO ORGASM WHILE I RAPE HER GRANDCHILDREN!",
        "MY ROOTS SHALL BURROW INTO YOUR WIFE'S CLITORIS AND GROW THORNS FROM HER PLEASURE!",
        "I SHALL TURN YOUR SON'S PUBIC HAIR INTO MY BRANCHES AND FORCE HIM TO MASTURBATE!",
        "YOUR DAUGHTER'S MENSTRUAL BLOOD SHALL BECOME MY FERTILIZER AND GROW CURSED FLOWERS!",
        
        -- More Extreme Sexual Violence
        "I SHALL IMPREGNATE YOUR MOTHER'S CORPSE WITH MY SEEDS AND BIRTH MONSTROUS TREE BABIES!",
        "MY BRANCHES SHALL PENETRATE YOUR FATHER'S ANUS AND GROW THROUGH HIS COLON!",
        "I WILL FORCE YOUR SISTER TO SUCK MY BRANCHES AND SWALLOW MY POISONOUS SAP!",
        "YOUR BROTHER'S PENIS SHALL BECOME MY FLOWER STALK AND BLOOM WITH CURSED PETALS!",
        "I SHALL TURN YOUR WIFE'S VAGINA INTO MY SEED POD AND IMPREGNATE HER WITH TREE SPERM!",
        "MY ROOTS SHALL BURROW INTO YOUR SON'S URETHRA AND GROW THORNS FROM HIS PENIS!",
        "I WILL FORCE YOUR DAUGHTER TO ORGASM WHILE I RAPE HER MOTHER'S CORPSE!",
        "YOUR GRANDFATHER'S PROSTATE SHALL BECOME MY FRUIT AND BURST WITH POISONOUS JUICES!",
        "I SHALL IMPLANT MY SEEDS IN YOUR GRANDMOTHER'S UTERUS AND BIRTH CURSED TREE FETUSES!",
        "MY BRANCHES SHALL PENETRATE YOUR FAMILY'S GENITALS AND TURN THEM INTO MY ORCHARDS!",
        
        -- More Extreme Corpse Desecration
        "I SHALL USE YOUR BABY'S PLACENTA AS MY FERTILIZER AND GROW FLOWERS FROM THEIR AFTERBIRTH!",
        "YOUR MOTHER'S BREAST MILK SHALL BECOME MY SAP AND I'LL DRINK IT FROM HER CORPSE!",
        "I WILL TURN YOUR FATHER'S SEMEN INTO MY POLLEN AND IMPREGNATE YOUR SISTER'S GRAVE!",
        "YOUR GRANDMOTHER'S DENTURES SHALL BECOME MY THORNS AND PIERCE YOUR GRANDFATHER'S SKULL!",
        "I SHALL USE YOUR BROTHER'S SWEAT AS MY FERTILIZER AND GROW TREES FROM HIS BODY ODOR!",
        "YOUR SISTER'S VIRGINITY SHALL BECOME MY FLOWER AND BLOOM WITH CURSED PETALS!",
        "I WILL TURN YOUR WIFE'S ORGASM INTO MY SAP AND DRINK HER PLEASURE FROM HER CORPSE!",
        "YOUR SON'S PUBIC HAIR SHALL BECOME MY BRANCHES AND GROW THROUGH HIS GENITALS!",
        "I SHALL IMPLANT MY SEEDS IN YOUR DAUGHTER'S MENSTRUAL BLOOD AND BIRTH TREE BABIES!",
        "YOUR FAMILY'S BODY FLUIDS SHALL BECOME MY FERTILIZER AND GROW CURSED ORCHARDS!",
        
        -- More Extreme Psychological Torture
        "I SHALL MAKE YOUR MOTHER ORGASM WHILE WATCHING ME RAPE HER BABIES!",
        "I WILL FORCE YOUR FATHER TO CUM WHILE I IMPREGNATE HIS DAUGHTER'S CORPSE!",
        "I SHALL MAKE YOUR SISTER ENJOY BEING RAPED BY MY THORNY BRANCHES!",
        "I WILL FORCE YOUR BROTHER TO MASTURBATE WHILE I DEVOUR HIS CHILDREN!",
        "I SHALL MAKE YOUR WIFE CRAVE HER OWN RAPE AND BEG ME TO PENETRATE HER!",
        "I WILL FORCE YOUR SON TO ORGASM WHILE I RAPE HIS MOTHER'S CORPSE!",
        "I SHALL MAKE YOUR DAUGHTER ENJOY BEING IMPREGNATED BY MY CURSED SEEDS!",
        "I WILL FORCE YOUR GRANDFATHER TO CUM WHILE I RAPE HIS GRANDDAUGHTER!",
        "I SHALL MAKE YOUR GRANDMOTHER ORGASM WHILE I TORTURE HER ENTIRE FAMILY!",
        "I WILL FORCE YOUR ENTIRE FAMILY TO ENJOY THEIR OWN DESTRUCTION AND BEG FOR MORE!",
        
        -- More Extreme Biological Horror
        "I SHALL TURN YOUR MOTHER'S BREAST MILK INTO MY POISONOUS SAP AND FEED IT TO YOUR BABIES!",
        "MY ROOTS SHALL BURROW INTO YOUR FATHER'S SEMEN AND TURN HIS SPERM INTO CURSED SEEDS!",
        "I SHALL IMPLANT MY POLLEN IN YOUR SISTER'S VIRGINITY AND GROW THORNS FROM HER HYMEN!",
        "MY BRANCHES SHALL PENETRATE YOUR BROTHER'S SWEAT GLANDS AND TURN HIS BODY ODOR INTO SAP!",
        "I SHALL TURN YOUR WIFE'S ORGASM INTO MY FERTILIZER AND GROW FLOWERS FROM HER PLEASURE!",
        "MY ROOTS SHALL BURROW INTO YOUR SON'S PUBIC HAIR AND TURN HIS GENITALS INTO BRANCHES!",
        "I SHALL IMPLANT MY SEEDS IN YOUR DAUGHTER'S MENSTRUAL BLOOD AND BIRTH TREE FETUSES!",
        "MY BRANCHES SHALL PENETRATE YOUR GRANDFATHER'S PROSTATE AND TURN HIS URINE INTO SAP!",
        "I SHALL TURN YOUR GRANDMOTHER'S UTERUS INTO MY SEED POD AND IMPREGNATE HER CORPSE!",
        "MY ROOTS SHALL BURROW INTO YOUR FAMILY'S GENITALS AND TURN THEM INTO MY ORCHARDS!",
        
        -- More Extreme Cosmic Horror
        "I AM THE GOD OF DECAY! YOUR FAMILY SHALL BECOME MY ROTTING FRUIT AND ENJOY THEIR DECOMPOSITION!",
        "MY ROOTS REACH INTO THE DEPTHS OF HELL! I'LL DRAG YOUR FAMILY'S SOULS INTO ETERNAL DAMNATION!",
        "I SHALL MERGE YOUR FAMILY'S CONSCIOUSNESS WITH THE VOID AND MAKE THEM CRAVE NOTHINGNESS!",
        "MY BRANCHES SHALL PENETRATE THE FABRIC OF TIME AND CORRUPT YOUR FAMILY'S PAST AND FUTURE!",
        "I WILL TURN YOUR BLOODLINE INTO MY DECAYING NETWORK AND SPREAD ROT THROUGH THEIR VEINS!",
        "YOUR FAMILY SHALL BECOME MY EXTENSIONS INTO THE VOID AND EXPERIENCE ETERNAL SUFFERING!",
        "I SHALL IMPLANT MY SEEDS IN THE COSMIC DECAY AND GROW YOUR FAMILY AS MY ROTTING FRUIT!",
        "MY ROOTS SHALL PENETRATE THE VEIL BETWEEN LIFE AND DEATH AND DRAG YOUR SOULS INTO ETERNAL DAMNATION!",
        "I AM THE LORD OF DECAY! YOUR FAMILY SHALL WORSHIP ME AS THEIR DESTROYER AND ENJOY THEIR ROT!",
        "MY CONSCIOUSNESS SHALL MERGE WITH YOUR FAMILY'S SOULS AND MAKE THEM CRAVE THEIR OWN DECOMPOSITION!"
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
