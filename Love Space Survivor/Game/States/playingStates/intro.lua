local state = {}

local enemy = require('Game/Enemy/enemy')
function state.load()

end

function state.update(dt)
	if state.countdown then
		state.countdown = state.countdown - dt
		if state.countdown <= 0 then
			return 'start'
		end
		state.player.x, state.player.y = MOUSE.x, MOUSE.y
	end
end

function state.draw()
	love.graphics.setColor(255,255,255)
	state.player:draw()

	if state.countdown then
		love.graphics.printf(math.ceil(state.countdown),0,80,window.width,'center')
	else
		love.graphics.printf('Click ship to play',0,80,window.width,'center')
	end
end

function state.keypressed(key)

end

function state.mousepressed(x,y,button)
	if button == 'l' and state.player.drawBox:collidePoint(x,y) and not state.countdown then
		state.countdown = 3
	end
end

return state