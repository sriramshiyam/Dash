background = {}

function background:load()
    self.list = {}
    self:update_list()
end

function background:update(dt)
    if player.dash_speed > 800 then
        self:handle_dash(dt)
        return
    end

    for i = 1, #objects.move_vectors do
        local move_vector = objects.move_vectors[i]
        for j = 1, #self.list do
            local object = self.list[j]
            object.x = object.x + move_vector.x * move_vector.speed / 1.75 * dt
            object.y = object.y + move_vector.y * move_vector.speed / 1.75 * dt
        end
    end
end

function background:update_list()
    for i = 1, 15 do
        table.insert(self.list,
            { x = love.math.random(-500, canvas_width + 500), y = love.math.random(-500, canvas_height + 500) })
    end
end

function background:handle_dash(dt)
    for j = 1, #self.list do
        local object = self.list[j]
        object.x = object.x + player.dash_vector.x * player.dash_speed / 1.75 * dt
        object.y = object.y + player.dash_vector.y * player.dash_speed / 1.75 * dt
    end
end

function background:draw()
    love.graphics.setColor(0.7, 0.7, 0.7)
    for i = 1, #self.list do
        love.graphics.circle("fill", self.list[i].x, self.list[i].y, 10)
    end
    love.graphics.setColor(1, 1, 1)
end
