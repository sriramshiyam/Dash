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
    self.dash_speed = 0
    self.dash_damping = 40000
    self.dash_vector = {}
    self.previous_points = {}
    self.points = {}
end

function player:update(dt)
    self:track_mouse()
    self.rotation = math.atan2(self.mouse_y - self.position.y, self.mouse_x - self.position.x) + (math.pi / 2)

    local x = self.position.x - self.mouse_x
    local y = self.position.y - self.mouse_y

    if self.dash_speed <= 800 then
        self.dash_vector.x = x
        self.dash_vector.y = y
        normalize_vector(self.dash_vector)
    end

    if self.dash_speed <= 800 then
        if #objects.move_vectors == 0 then
            table.insert(objects.move_vectors, { x = x, y = y, speed = 0, damping = 300 })
        else
            local last_vector = objects.move_vectors[#objects.move_vectors]
            if last_vector.x ~= x or last_vector.y ~= y then
                table.insert(objects.move_vectors, { x = x, y = y, speed = 0, damping = 300 })
            end
        end
    end

    if self.dash_speed > 800 then
        self.dash_speed = self.dash_speed - self.dash_damping * dt
        self.dash_damping = self.dash_damping - 1000 * dt
    else
        self.previous_points = nil
    end

    self:update_points()
end

function player:update_points()
    local point1 = { x = 0, y = -50 }
    local point2 = { x = 50, y = 40 }
    local point3 = { x = -50, y = 40 }

    rotate_vector(point1, self.rotation)
    rotate_vector(point2, self.rotation)
    rotate_vector(point3, self.rotation)

    point1.x, point1.y = point1.x + self.position.x, point1.y + self.position.y
    point2.x, point2.y = point2.x + self.position.x, point2.y + self.position.y
    point3.x, point3.y = point3.x + self.position.x, point3.y + self.position.y

    self.points[1] = point1
    self.points[2] = point2
    self.points[3] = point3
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
