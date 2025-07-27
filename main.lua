require "sprites.player"
require "sprites.object"

canvas_width = 1536
canvas_height = 864

local canvas
canvas_offset_x = 0
canvas_offset_y = 0
scale = 1

function normalize_vector(vector)
    local length = math.sqrt(vector.x ^ 2 + vector.y ^ 2)
    vector.x = vector.x / length
    vector.y = vector.y / length
end

function love.load()
    canvas = love.graphics.newCanvas(canvas_width, canvas_height)
    love.window.setTitle("DASH")
    love.window.setMode(800, 600, { resizable = true })
    love.window.maximize()
    love.graphics.setDefaultFilter("linear", "linear")
    player:load()
    objects:load()
end

function love.update(dt)
    player:update(dt)
    objects:update(dt)
end

function love.draw()
    love.graphics.setCanvas(canvas)
    love.graphics.clear(0.1, 0.1, 0.1)
    player:draw()
    objects:draw()
    love.graphics.setCanvas()
    love.graphics.clear()
    love.graphics.draw(canvas, canvas_offset_x, canvas_offset_y, 0, scale, scale)
end

function love.resize(window_width, window_height)
    scale = math.min(window_width / canvas_width, window_height / canvas_height)
    canvas_offset_x = (window_width - canvas_width * scale) / 2
    canvas_offset_y = (window_height - canvas_height * scale) / 2
end

function love.keypressed(key)
    if key == "space" and player.dash_speed <= 800 then
        player.dash_speed = 7000
        player.dash_damping = 40000

        for i = #objects.move_vectors, 1, -1 do
            local move_vector = objects.move_vectors[i]
            if move_vector.x ~= player.dash_vector.x or move_vector.y ~= player.dash_vector.y then
                table.remove(objects.move_vectors, i)
            end
        end

        if #objects.move_vectors == 0 then
            for i = 1, 10 do
                local vector = { x = player.dash_vector.x, y = player.dash_vector.y, speed = 50, damping = 300 }
                table.insert(objects.move_vectors, vector)
            end
        end
    end
end
