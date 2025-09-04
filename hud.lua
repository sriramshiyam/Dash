hud = {}

function hud:load()
    self.score_font = love.graphics.newFont("res/fonts/upheavtt.ttf", 80)
    self.score_list = {}
end

function hud:update(dt)
    for i = #self.score_list, 1, -1 do
        local score = self.score_list[i]
        score.x = score.object.x - self.score_font:getWidth(score.text) / 2
        score.y = score.object.y - 100
        score.alpha = score.alpha - dt
        if score.alpha < 0 then
            table.remove(self.score_list, i)
        end
    end
end

function hud:add_score(score, object)
    for i = #self.score_list, 1, -1 do
        if self.score_list[i].object.id == object.id then
            table.remove(self.score_list, i)
        end
    end
    local text = string.format("+%d", score)
    local x = object.x
    local y = object.y - 100
    x = x - self.score_font:getWidth(text) / 2
    table.insert(self.score_list, { text = text, x = x, y = y, alpha = 1, object = object })
end

function hud:draw()
    love.graphics.setFont(self.score_font)
    for i = 1, #self.score_list do
        local score = self.score_list[i]
        love.graphics.setColor(1, 1, 1, score.alpha)
        love.graphics.print(score.text, score.x, score.y)
        love.graphics.setColor(1, 1, 1, 1)
    end
    love.graphics.setFont(default_font)
end
