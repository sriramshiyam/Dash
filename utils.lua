function normalize_vector(vector)
    local length = math.sqrt(vector.x ^ 2 + vector.y ^ 2)
    vector.x = vector.x / length
    vector.y = vector.y / length
end

function rotate_vector(vector, radian)
    local cos = math.cos(radian)
    local sin = math.sin(radian)

    vector.x, vector.y = vector.x * cos - vector.y * sin, vector.x * sin + vector.y * cos
end

function length_of_vector(vector)
    return math.sqrt(vector.x ^ 2 + vector.y ^ 2)
end

function line_and_circle_collision(line, circle)
    if (length_of_vector({ x = line.x1 - circle.cx, y = line.y1 - circle.cy }) <= circle.radius) or
        (length_of_vector({ x = line.x2 - circle.cx, y = line.y2 - circle.cy }) <= circle.radius) then
        return true
    end

    local u = { x = circle.cx - line.x1, y = circle.cy - line.y1 }
    local v = { x = line.x2 - line.x1, y = line.y2 - line.y1 }

    local factor = (u.x * v.x + u.y * v.y) / (length_of_vector(v) ^ 2)

    if factor >= 0 and factor <= 1 then
        local w = { x = v.x * factor, y = v.y * factor }

        local proj = { x = line.x1 + w.x - circle.cx, y = line.y1 + w.y - circle.cy }
        if length_of_vector(proj) <= circle.radius then
            return true
        end
    end

    return false
end

function circle_and_circle_collision(circle1, circle2)
    return length_of_vector({ x = circle1.x - circle2.x, y = circle1.y - circle2.y }) <=
        (circle1.radius + circle2.radius)
end

function line_and_line_collision(line1, line2)
    local x1, y1 = line1.x1, line1.y1
    local x2, y2 = line1.x2, line1.y2
    local x3, y3 = line2.x1, line2.y1
    local x4, y4 = line2.x2, line2.y2

    local uA = ((x4 - x3) * (y1 - y3) - (y4 - y3) * (x1 - x3)) / ((y4 - y3) * (x2 - x1) - (x4 - x3) * (y2 - y1));

    local uB = ((x2 - x1) * (y1 - y3) - (y2 - y1) * (x1 - x3)) / ((y4 - y3) * (x2 - x1) - (x4 - x3) * (y2 - y1));

    return uA >= 0 and uA <= 1 and uB >= 0 and uB <= 1
end
