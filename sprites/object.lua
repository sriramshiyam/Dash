objects = {}

function objects:load()
    self.textures = {
        love.graphics.newImage("res/image/object1.png"),
        love.graphics.newImage("res/image/object2.png"),
        love.graphics.newImage("res/image/object3.png"),
        love.graphics.newImage("res/image/object4.png")
    }

    self.list = {}

    for i = 1, 10 do
        table.insert(self.list,
            { texture = love.math.random(4), x = love.math.random(canvas_width), y = love.math.random(canvas_height) })
    end

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
end

function objects:handle_dash(dt)

    for j = 1, #self.list do
        local object = self.list[j]
        object.x = object.x + player.dash_vector.x * player.dash_speed * dt
        object.y = object.y + player.dash_vector.y * player.dash_speed * dt
    end
end

function objects:draw()
    for i = 1, #self.list do
        local object = self.list[i]
        love.graphics.draw(self.textures[object.texture], object.x, object.y)
    end
end
