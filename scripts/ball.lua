local Ball = {}

function Ball:load()
    self.x = love.graphics.getWidth() / 2
    self.y = love.graphics.getHeight() / 2
    self.radius = 10
    self.speedx = 300
    self.speedy = 300
    self.trail = {}
end

function Ball:update(dt)
    table.insert(self.trail, 1, {x = self.x, y = self.y})
    if #self.trail > 10 then
        table.remove(self.trail)
    end

    self.x = self.x + self.speedx * dt
    self.y = self.y + self.speedy * dt

    if self.y - self.radius < 0 or self.y + self.radius > love.graphics.getHeight() then
        self.speedy = -self.speedy 
        wallSound:play()
    end
end

function Ball:checkCollision(player1, player2)
    if self.x - self.radius < player1.x + player1.width and 
       self.x - self.radius > player1.x and
       self.y > player1.y and 
       self.y < player1.y + player1.height then
        
        local relativeIntersectY = (player1.y + (player1.height / 2)) - self.y
        local normalizedIntersectY = relativeIntersectY / (player1.height / 2)
        
        self.speedy = normalizedIntersectY * -300
        
        self.speedx = -self.speedx
        hitSound:play()
        return true

    elseif self.x + self.radius > player2.x and
           self.x + self.radius < player2.x + player2.width and
           self.y > player2.y and
           self.y < player2.y + player2.height then
        
        local relativeIntersectY = (player2.y + (player2.height / 2)) - self.y
        local normalizedIntersectY = relativeIntersectY / (player2.height / 2)
        
        self.speedy = normalizedIntersectY * -300

        self.speedx = -self.speedx
        hitSound:play()
        return true
    end

    return false
end

function Ball:draw()
    for i, p in ipairs(self.trail) do
        local alpha = 1 - (i / #self.trail)
        love.graphics.setColor(1, 1, 1, alpha * 0.5)
        love.graphics.circle("fill", p.x, p.y, self.radius)
    end
    
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.circle("fill", self.x, self.y, self.radius)
end

function Ball:reset()
    self.x = love.graphics.getWidth() / 2
    self.y = love.graphics.getHeight() / 2
    self.speedx = -self.speedx
end

return Ball