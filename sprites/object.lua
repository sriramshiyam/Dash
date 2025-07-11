objects = {}

local function normalize_vector(vector)
    local length = math.sqrt(vector.x ^ 2 + vector.y ^ 2)
    vector.x = vector.x / length
    vector.y = vector.y / length
end

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
    self.move_speed = 0
end

function objects:update(dt)
    normalize_vector(self.move_vectors[#self.move_vectors])

    for i = #self.move_vectors, 1, -1 do
        local move_vector = self.move_vectors[i]

        if i == #self.move_vectors then
            if love.keyboard.isDown("w") then
                if move_vector.speed < 800 then
                    move_vector.speed = move_vector.speed + 2000 * dt
                end
            else
                if move_vector.speed > 0 then
                    move_vector.speed = move_vector.speed - 1000 * dt
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

function objects:draw()
    for i = 1, #self.list do
        local object = self.list[i]
        love.graphics.draw(self.textures[object.texture], object.x, object.y)
    end
end
