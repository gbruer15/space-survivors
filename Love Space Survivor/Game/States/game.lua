local state = {}

function state.load()
	state.player = require("Game/Player/player").make()

end

function state.update(dt)
	state.player:update(dt)
end

function state.draw()
	state.player:draw()

	love.graphics.setColor(255,255,255)
	love.graphics.circle('fill',window.width/2,window.height/2,2)
end

function state.keypressed(key)

end

function state.mousepressed(x,y,button)

end

return state