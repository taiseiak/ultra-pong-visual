local paddleShader
local gaussianBlurShader
local metallic = 1.0
local roughness = 0.5
local dispersionStrength = 0.02
local canvas, bloomCanvas, blurCanvas, backgroundCanvas
local environmentMap
local backgroundShader
local startTime

local topLim = 50
local bottomLim = 550
local leftLim = 50
local rightLim = 750

local leftPaddle = {
    x = 100,
    y = 400,
    width = 12,
    height = 50,
    speed = 300
}

local rightPaddle = {
    x = 700,
    y = 400,
    width = 10,
    height = 50,
    speed = 300
}

local ball = {
    x = (rightLim - leftLim) * 0.5 + leftLim,
    y = (bottomLim - topLim) * 0.5 + topLim,
    dx = -180,
    dy = 180,
    radius = 8,
    speed = 180
}

local fieldEdges = {
    top = {
        x1 = leftLim,
        y1 = topLim,
        x2 = rightLim,
        y2 = topLim
    },
    right = {
        x1 = rightLim,
        y1 = topLim,
        x2 = rightLim,
        y2 = bottomLim
    },
    bottom = {
        x1 = leftLim,
        y1 = bottomLim,
        x2 = rightLim,
        y2 = bottomLim
    },
    left = {
        x1 = leftLim,
        y1 = topLim,
        x2 = leftLim,
        y2 = bottomLim
    },
}


local function drawActors()
    -- Left paddle
    love.graphics.rectangle("fill", leftPaddle.x, leftPaddle.y, leftPaddle.width, leftPaddle.height)

    -- Right paddle
    love.graphics.rectangle("fill", rightPaddle.x, rightPaddle.y, rightPaddle.width, rightPaddle.height)

    -- Ball
    love.graphics.circle("fill", ball.x, ball.y, ball.radius)
end

local function drawScene()
    -- Draw edges
    love.graphics.line(fieldEdges.top.x1, fieldEdges.top.y1, fieldEdges.top.x2, fieldEdges.top.y2)
    love.graphics.line(fieldEdges.right.x1, fieldEdges.right.y1, fieldEdges.right.x2, fieldEdges.right.y2)
    love.graphics.line(fieldEdges.bottom.x1, fieldEdges.bottom.y1, fieldEdges.bottom.x2, fieldEdges.bottom.y2)
    love.graphics.line(fieldEdges.left.x1, fieldEdges.left.y1, fieldEdges.left.x2, fieldEdges.left.y2)

    -- Mid line
    love.graphics.line(400, 0, 400, 700)
end


function love.load()
    startTime = love.timer.getTime()
    love.window.setTitle("Ultra Pong")

    paddleShader = love.graphics.newShader("metallic.fs")
    backgroundShader = love.graphics.newShader("background_shader.fs")

    canvas = love.graphics.newCanvas()
    backgroundCanvas = love.graphics.newCanvas()

    -- Load the environment map
    environmentMap = love.graphics.newImage("environment_map.png")
    paddleShader:send("environmentMap", environmentMap)


    -- Set paddleShader uniforms
    paddleShader:send("viewPosition", { love.graphics.getWidth() / 2, love.graphics.getHeight() / 2 })
    paddleShader:send("metallic", metallic)
    -- paddleShader:send("roughness", roughness)
    paddleShader:send("dispersionStrength", dispersionStrength)

    backgroundShader:send("time", 0.0)
    backgroundShader:send("a", { 0.5, 0.5, 0.5 })
    backgroundShader:send("b", { 0.5, 0.5, 0.5 })
    backgroundShader:send("c", { 1.0, 1.0, 1.0 })
    backgroundShader:send("d", { 0.263, 0.416, 0.557 })
    -- backgroundShader:send("uvOffset", canvas:getWidth())
end

function love.update(dt)
    local time = love.timer.getTime()

    -- Update shaders
    backgroundShader:send("time", time - startTime)

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
    if ball.y - ball.radius <= topLim or ball.y + ball.radius >= bottomLim then
        ball.dy = -ball.dy
    end
    if ball.x + ball.radius < 0 or ball.x - ball.radius >= rightLim then
        ball.x = (rightLim - leftLim) * 0.5 + leftLim
        ball.y = (bottomLim - topLim) * 0.5 + topLim
        ball.dx = -ball.speed
    end
    -- Check for top collision
    local ballMiddlePosition = ball.y + ball.radius
    if ballMiddlePosition >= leftPaddle.y and
        ballMiddlePosition <= leftPaddle.y + leftPaddle.height and
        ball.x <= leftPaddle.x + leftPaddle.width and
        ball.x >= leftPaddle.x then
        ball.x = leftPaddle.x + leftPaddle.width + ball.radius
        ball.dx = -ball.dx
    end
    -- Update ball position
    ball.x = ball.x + ball.dx * dt
    ball.y = ball.y + ball.dy * dt

    local r = (math.sin(time) + 1) / 2
    local g = (math.sin(time + 2) + 1) / 2
    local b = (math.sin(time + 4) + 1) / 2
    -- shaders["paddleShader"]:send("newColor", { 1.0, ball.x / rightLim, ball.y / bottomLim, 1.0 })
end

function love.draw()
    -- Render the background
    love.graphics.setCanvas(backgroundCanvas)
    love.graphics.clear()
    love.graphics.setShader(backgroundShader)
    -- Draw a rectangle that fills the whole screen
    love.graphics.rectangle("fill", 0, 0, love.graphics.getWidth(), love.graphics.getHeight())
    love.graphics.setShader()
    love.graphics.setCanvas()

    -- Render the scene to the canvas
    love.graphics.setCanvas(canvas)
    love.graphics.clear()
    love.graphics.setShader()
    drawActors()
    love.graphics.setShader()
    love.graphics.setCanvas()

    -- love.graphics.setCanvas(bloomCanvas)
    -- love.graphics.clear()
    -- love.graphics.setShader(bloomShader)
    -- love.graphics.draw(canvas)
    -- love.graphics.setShader()
    -- love.graphics.setCanvas()

    -- love.graphics.setCanvas(blurCanvas)
    -- love.graphics.clear(1, 1, 1, 0)
    -- love.graphics.setShader(gaussianBlurShader)
    -- love.graphics.draw(bloomCanvas)
    -- love.graphics.setShader()
    -- love.graphics.setCanvas()

    love.graphics.draw(backgroundCanvas, 0, 0)
    -- love.graphics.setBlendMode("add")
    love.graphics.draw(canvas)
    -- love.graphics.draw(blurCanvas)
    love.graphics.setBlendMode("alpha")
end
