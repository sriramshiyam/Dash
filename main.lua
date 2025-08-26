require "utils"
require "sprites.player"
require "sprites.object"
require "sprites.background"

canvas_width = 1280
canvas_height = 720

local canvas
canvas_offset_x = 0
canvas_offset_y = 0
scale = 1



function love.load()
    canvas = love.graphics.newCanvas(canvas_width, canvas_height)
    love.window.setTitle("DASH")
    love.window.setMode(800, 600, { resizable = true })
    love.window.maximize()
    love.graphics.setDefaultFilter("linear", "linear")
    player:load()
    objects:load()
    background:load()
end

function love.update(dt)
    player:update(dt)
    objects:update(dt)
    background:update(dt)
end

function love.draw()
    love.graphics.setCanvas(canvas)
    love.graphics.clear(0.1, 0.1, 0.1)
    background:draw()
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
        player.dash_speed = 6000
        player.dash_damping = 40000

        objects.move_vectors = {}

        for i = 1, 15 do
            local vector = { x = player.dash_vector.x, y = player.dash_vector.y, speed = 25, damping = 300 }
            table.insert(objects.move_vectors, vector)
        end
    end
end
