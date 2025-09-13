local ParticleSystem = {}

function ParticleSystem:load()
    self.particles = {}
end

function ParticleSystem:update(dt)
    for i = #self.particles, 1, -1 do
        local p = self.particles[i]
        p.x = p.x + p.speedX * dt
        p.y = p.y + p.speedY * dt
        p.lifespan = p.lifespan - dt
        
        if p.lifespan <= 0 then
            table.remove(self.particles, i)
        end
    end
end

function ParticleSystem:spawn(x, y)
    for i = 1, 15 do
        local p = {}
        p.x = x
        p.y = y
        p.size = 3
        p.speedX = love.math.random(-150, 150)
        p.speedY = love.math.random(-150, 150)
        p.lifespan = love.math.random(0.3, 0.8)

        table.insert(self.particles, p)
    end
end

function ParticleSystem:draw()
    for i, p in ipairs(self.particles) do
        love.graphics.setColor(1, 1, 1, p.lifespan)
        love.graphics.rectangle("fill", p.x, p.y, p.size, p.size)
    end
end

return ParticleSystem