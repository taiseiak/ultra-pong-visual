local leftPaddle = {
    x = 100,
    y = 400,
    width = 2,
    height = 50,
    speed = 300
}

local rightPaddle = {
    x = 700,
    y = 400,
    width = 2,
    height = 50,
    speed = 300
}

local fieldEdges = {
    top = {
        x1 = 50,
        y1 = 50,
        x2 = 750,
        y2 = 50
    },
    right = {
        x1 = 750,
        y1 = 50,
        x2 = 750,
        y2 = 550
    },
    bottom = {
        x1 = 50,
        y1 = 550,
        x2 = 750,
        y2 = 550
    },
    left = {
        x1 = 50,
        y1 = 50,
        x2 = 50,
        y2 = 550
    },
}

function love.load()
    love.window.setTitle("Ultra Pong")
end

function love.update(dt) 
    if love.keyboard.isDown("s") then
        leftPaddle.y = math.min(leftPaddle.y + leftPaddle.speed * dt, 500)
    end
    if love.keyboard.isDown("w") then
        leftPaddle.y = math.max(leftPaddle.y - leftPaddle.speed * dt, 50)
    end
    if love.keyboard.isDown("down") then
        rightPaddle.y = math.min(rightPaddle.y + rightPaddle.speed * dt, 500)
    end
    if love.keyboard.isDown("up") then
        rightPaddle.y = math.max(rightPaddle.y - rightPaddle.speed * dt, 50)
    end
end

function love.draw()
    -- Draw edges
    love.graphics.line(fieldEdges.top.x1, fieldEdges.top.y1, fieldEdges.top.x2, fieldEdges.top.y2)
    love.graphics.line(fieldEdges.right.x1, fieldEdges.right.y1, fieldEdges.right.x2, fieldEdges.right.y2)
    love.graphics.line(fieldEdges.bottom.x1, fieldEdges.bottom.y1, fieldEdges.bottom.x2, fieldEdges.bottom.y2)
    love.graphics.line(fieldEdges.left.x1, fieldEdges.left.y1, fieldEdges.left.x2, fieldEdges.left.y2)

    -- Left paddle
    love.graphics.rectangle("fill", leftPaddle.x, leftPaddle.y, leftPaddle.width, leftPaddle.height)

    -- Right paddle
    love.graphics.rectangle("fill", rightPaddle.x, rightPaddle.y, rightPaddle.width, rightPaddle.height)

    -- Ball
    love.graphics.circle("fill", 200, 200, 8)
    
    -- Mid line
    love.graphics.line(400, 0, 400, 700)
end