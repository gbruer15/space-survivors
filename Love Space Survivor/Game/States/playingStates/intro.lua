local state = {}

local enemy = require('Game/Enemy/enemy')
function state.load()
	STATE.player.x = STATE.camera.x
	STATE.player.y = STATE.camera.y
end

function state.update(dt)
	STATE.hud:update(dt)
	if state.countdown then
		state.countdown = state.countdown - dt*1.5
		if state.countdown <= 0 then
			state.countdown = nil
			return 'start'
		end
			STATE.player:move(dt)
		else
	end
end

function state.draw()
	if state.countdown then
		love.graphics.printf(math.ceil(state.countdown),0,80,STATE.camera.width,'center')
	else
		if STATE.player.mouseControl then
			love.graphics.printf('Click ship to play',0,80,STATE.camera.width,'center')
		else
			love.graphics.printf('Unpause to start',0,80,STATE.camera.width,'center')
		end
	end
end

function state.keypressed(key)
	if not STATE.player.mouseControl and key == 'p' and not state.countdown then
		STATE.paused = false
	end
end

function state.mousepressed(x,y,button)
	if button == 'l' and STATE.player.drawBox:collidePoint(x,y) and not state.countdown then
		state.countdown = 3
	end
end

return state