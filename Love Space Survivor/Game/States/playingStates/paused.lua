local state = {}

function state.load()
end

function state.update(dt)
	STATE.hud:update(dt)
end

function state.draw()
	if state.countdown then
		love.graphics.printf(math.ceil(state.countdown),0,80,STATE.camera.width,'center')
	else
		love.graphics.printf('Click ship to play',0,80,STATE.camera.width,'center')
	end
end

function state.keypressed(key)
	if not STATE.player.mouseControl and key == 'p' then
		STATE.paused = false
		STATE.state = STATE.states.playing
	end
end

function state.mousepressed(x,y,button)
	if button == 'l' and STATE.player.drawBox:collidePoint(x,y) then
		STATE.paused = false
		STATE.state = STATE.states.playing
	else
		STATE.hud:mousepressed(x,y,button)
	end
end

return state