Ball = require('scripts.ball')
ParticleSystem = require('scripts.particle_system')

function love.load()
    love.window.setTitle("MINIMALIST PONG")
    love.window.setMode(800, 600)

    gameState = "start"
    WIN_SCORE = 5
    bigFont = love.graphics.newFont(50)
    scoreFont = love.graphics.newFont(40)
    smallFont = love.graphics.newFont(20)

    Ball:load()
    ParticleSystem:load()

    player1 = {
        x = 50, y = 250, width = 20, height = 100, speed = 400
    }
    player2 = {
        x = 730, y = 250, width = 20, height = 100, speed = 360
    }

    score1 = 0
    score2 = 0

    hitSound = love.audio.newSource("assets/hit.wav", "static")
    wallSound = love.audio.newSource("assets/wall.wav", "static")
    scoreSound = love.audio.newSource("assets/score.wav", "static")

    music = love.audio.newSource("assets/music.mp3", "stream")
    music:setLooping(true)
    music:setVolume(0.5)

    shakeDuration = 0
    shakeMagnitude = 4
end

function love.update(dt)
    if shakeDuration > 0 then
        shakeDuration = shakeDuration - dt
    end

    if gameState == 'start' then
        if love.keyboard.isDown('return') then
            gameState = 'play'
            music:play()
        end
    elseif gameState == 'play' then
        if love.keyboard.isDown("s") and player1.y < love.graphics.getHeight() - player1.height then
            player1.y = player1.y + player1.speed * dt
        elseif love.keyboard.isDown("w") and player1.y > 0 then
            player1.y = player1.y - player1.speed * dt
        end

        if Ball.speedx > 0 then
            local player2_centerY = player2.y + player2.height / 2
            if player2_centerY < Ball.y - 5 then
                player2.y = player2.y + player2.speed * dt
            elseif player2_centerY > Ball.y + 5 then
                player2.y = player2.y - player2.speed * dt
            end
        end
        
        Ball:update(dt)
        ParticleSystem:update(dt)

        if Ball:checkCollision(player1, player2) then
            ParticleSystem:spawn(Ball.x, Ball.y)
        end

        if Ball.x < 0 then
            score2 = score2 + 1
            scoreSound:play()
            shakeDuration = 0.2
            if score2 >= WIN_SCORE then
                winner = "Oponent"
                gameState = 'game_over'
                music:stop()
            else
                Ball:reset()
            end
        elseif Ball.x > love.graphics.getWidth() then
            score1 = score1 + 1
            scoreSound:play()
            shakeDuration = 0.2
            if score1 >= WIN_SCORE then
                winner = "Player"
                gameState = 'game_over'
                music:stop()
            else
                Ball:reset()
            end
        end
    elseif gameState == 'game_over' then
        if love.keyboard.isDown('return') then
            score1 = 0
            score2 = 0
            Ball:load()          
            gameState = 'start'
        end
    end
end

function love.draw()
    love.graphics.push()
    if shakeDuration > 0 then
        local dx = love.math.random(-shakeMagnitude, shakeMagnitude)
        local dy = love.math.random(-shakeMagnitude, shakeMagnitude)
        love.graphics.translate(dx, dy)
    end

    love.graphics.clear(0.1, 0.1, 0.1, 1)

    if gameState == 'start' then
        love.graphics.setFont(bigFont)
        love.graphics.printf("MINIMALIST PONG", 0, 200, love.graphics.getWidth(), "center")
        love.graphics.setFont(scoreFont)
        love.graphics.printf("Press ENTER to start", 0, 300, love.graphics.getWidth(), "center")
        love.graphics.setFont(smallFont)
        love.graphics.printf("Use 'W' and 'S' to move up and down", 0, 500, love.graphics.getWidth(), "center")

    elseif gameState == 'play' then
        love.graphics.setColor(1, 1, 1)
        love.graphics.setFont(scoreFont)
        love.graphics.print(score1, 350, 50)
        love.graphics.print(score2, 430, 50)
        
        drawDashedLine()

        love.graphics.setColor(0, 1, 1)
        love.graphics.rectangle("fill", player1.x, player1.y, player1.width, player1.height)
        
        love.graphics.setColor(1, 0, 0)
        love.graphics.rectangle("fill", player2.x, player2.y, player2.width, player2.height)
        
        love.graphics.setColor(1, 1, 1)
        Ball:draw()
        
        ParticleSystem:draw()
        love.graphics.setColor(1, 1, 1, 1)

    elseif gameState == 'game_over' then
        love.graphics.setFont(bigFont)
        love.graphics.printf(winner .. " Won!", 0, 200, love.graphics.getWidth(), "center")
        love.graphics.setFont(scoreFont)
        love.graphics.printf("Press ENTER to play again.", 0, 300, love.graphics.getWidth(), "center")
    end
    
    love.graphics.pop()
end

function drawDashedLine()
    local x = love.graphics.getWidth() / 2
    local y = 0
    local segment_height = 15
    local gap_height = 10
    while y < love.graphics.getHeight() do
        love.graphics.rectangle("fill", x - 2, y, 4, segment_height)
        y = y + segment_height + gap_height
    end
end