player = {}

function player:load()
    self.texture = love.graphics.newImage("res/image/player.png")
    self.position = {
        x = canvas_width / 2,
        y = canvas_height / 2
    }
    self.rotation = 0
    self.mouse_x = 0
    self.mouse_y = 0
end

function player:update(dt)
    self:track_mouse()
    self.rotation = math.atan2(self.position.y - self.mouse_y, self.position.x - self.mouse_x) - (math.pi / 2)

    local x = self.position.x - self.mouse_x
    local y = self.position.y - self.mouse_y

    if #objects.move_vectors == 0 then
        table.insert(objects.move_vectors, { x = x, y = y, speed = 0 })
    else
        local last_vector = objects.move_vectors[#objects.move_vectors]

        if last_vector.x ~= x or last_vector.y ~= y then
            table.insert(objects.move_vectors, { x = x, y = y, speed = 0 })
        end
    end
end

function player:draw()
    love.graphics.draw(self.texture, self.position.x, self.position.y, self.rotation, 1, 1, self.texture:getWidth() / 2,
        self.texture:getHeight() / 2)
end

function player:track_mouse()
    local window_width, window_height = love.graphics.getDimensions()

    local x, y = love.mouse.getPosition()

    if (y > canvas_offset_y and y < (window_height - canvas_offset_y)) and
        (x > canvas_offset_x and x < (window_width - canvas_offset_x)) then
        self.mouse_x = (x - canvas_offset_x) / (window_width - canvas_offset_x * 2) * canvas_width
        self.mouse_y = (y - canvas_offset_y) / (window_height - canvas_offset_y * 2) * canvas_height
    end
end
