objects = {}

function objects:load()
    self.textures = {
        love.graphics.newImage("res/image/object1.png"),
        love.graphics.newImage("res/image/object2.png"),
        love.graphics.newImage("res/image/object3.png"),
        love.graphics.newImage("res/image/object4.png")
    }

    self.list = {}
    self:update_list()
    self.move_vectors = {}
    self.dash_vector = { x = 0, y = 0, speed = 0 }
end

function objects:update(dt)
    if #self.move_vectors > 0 then
        normalize_vector(self.move_vectors[#self.move_vectors])
    end

    if player.dash_speed > 800 then
        self:handle_dash(dt)
        return
    end

    for i = #self.move_vectors, 1, -1 do
        local move_vector = self.move_vectors[i]

        if i == #self.move_vectors then
            if love.keyboard.isDown("w") then
                if move_vector.speed < 800 then
                    move_vector.speed = move_vector.speed + 1500 * dt
                end
            else
                if move_vector.speed > 0 then
                    move_vector.speed = move_vector.speed - move_vector.damping * dt
                    move_vector.damping = move_vector.damping - dt
                end
            end
        else
            move_vector.speed = move_vector.speed - 25 * dt
        end

        if move_vector.speed > 0 then
            for j = 1, #self.list do
                local object = self.list[j]
                object.x = object.x + move_vector.x * move_vector.speed * dt
                object.y = object.y + move_vector.y * move_vector.speed * dt
            end
        else
            table.remove(self.move_vectors, i)
        end
    end

    if player.previous_points ~= nil then
        self:check_collision_with_player()
    end
end

function objects:handle_dash(dt)
    for j = 1, #self.list do
        local object = self.list[j]
        object.x = object.x + player.dash_vector.x * player.dash_speed * dt
        object.y = object.y + player.dash_vector.y * player.dash_speed * dt
    end
    if player.previous_points == nil then
        player.previous_points = {}
        player.previous_points[1] = {
            x = player.points[1].x + player.dash_vector.x * player.dash_speed * 4 * dt,
            y = player.points[1].y + player.dash_vector.y * player.dash_speed * 4 * dt
        }
        player.previous_points[2] = {
            x = player.points[2].x + player.dash_vector.x * player.dash_speed * 4 * dt,
            y = player.points[2].y + player.dash_vector.y * player.dash_speed * 4 * dt
        }
        player.previous_points[3] = {
            x = player.points[3].x + player.dash_vector.x * player.dash_speed * 4 * dt,
            y = player.points[3].y + player.dash_vector.y * player.dash_speed * 4 * dt
        }
    end
end

function objects:update_list()
    for i = 1, 10 do
        local object = {
            texture = love.math.random(4),
            x = love.math.random(canvas_width),
            y = love.math.random(canvas_height),
            collided = false
        }
        table.insert(self.list, object)
    end
end

function objects:check_collision_with_player()
    for i = 1, #self.list do
        local object = self.list[i]
        local point1, previous_point1 = player.points[1], player.previous_points[1]
        local point2, previous_point2 = player.points[2], player.previous_points[2]
        local point3, previous_point3 = player.points[3], player.previous_points[3]

        if not object.collided and length_of_vector({ x = point1.x - previous_point1.x, y = point1.y - previous_point1.y }) then
            if line_and_circle_collision({ x1 = point1.x, x2 = previous_point1.x, y1 = point1.y, y2 = previous_point1.y },
                    { cx = object.x + 50.5, cy = object.y + 50.5, radius = 50 }) then
                object.collided = true
            end
        end

        if not object.collided and length_of_vector({ x = point2.x - previous_point2.x, y = point2.y - previous_point2.y }) then
            if line_and_circle_collision({ x1 = point2.x, x2 = previous_point2.x, y1 = point2.y, y2 = previous_point2.y },
                    { cx = object.x + 50.5, cy = object.y + 50.5, radius = 50 }) then
                object.collided = true
            end
        end

        if not object.collided and length_of_vector({ x = point3.x - previous_point3.x, y = point3.y - previous_point3.y }) then
            if line_and_circle_collision({ x1 = point3.x, x2 = previous_point3.x, y1 = point3.y, y2 = previous_point3.y },
                    { cx = object.x + 50.5, cy = object.y + 50.5, radius = 50 }) then
                object.collided = true
            end
        end
    end
end

function objects:draw()
    for i = 1, #self.list do
        local object = self.list[i]
        if object.collided then
            love.graphics.setColor(0, 0, 0)
            love.graphics.draw(self.textures[object.texture], object.x, object.y)
            love.graphics.setColor(1, 1, 1)
        else
            love.graphics.draw(self.textures[object.texture], object.x, object.y)
        end
    end
end
