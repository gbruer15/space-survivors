local state = {}

function state.load()
	state.hue = 0
	state.hueSpeed = 45
	--state.countdown = 5

	state.text = 'You won!'
end

function state.update(dt)
	state.hue = state.hue + state.hueSpeed*dt

	STATE.player.x, STATE.player.y = MOUSE.x, MOUSE.y
	if state.countdown then
		state.countdown = state.countdown - dt*1.5
		if state.countdown <= 0 then
			state.countdown = nil
			--add something here
		end
	end	
end

function state.draw()

	love.graphics.setColor(state.getRgbFromH(state.hue))

	local rgb = state.getRgbFromH(state.hue)

	love.graphics.print(rgb[1],0,0)
	love.graphics.print(rgb[2],0,15)
	love.graphics.print(rgb[3],0,30)

	love.graphics.printf(state.text,STATE.camera.x-STATE.camera.width/2,STATE.camera.y,STATE.camera.width,'center')
end

function state.keypressed(key)
end

function state.mousepressed(x,y,button)

end


function state.getRgbFromH(h)
	local a = 255
	local b = 255*math.abs(h/60 % 2 - 1)


	local rgb = {0,0,0}
	rgb[math.floor(h/120) % 3 + 1] = a
	rgb[3-math.floor(h/60) % 3] = b

	return rgb
	--[[
	if h < 60 then
		return {a,b,0}
	elseif h < 120 then
		return {b,a,0}
	elseif h < 180 then
		return {0,a,b}
	elseif h < 240 then
		return {0,b,a}
	elseif h < 300 then
		return {b,0,a}
	elseif h < 360 then
		return {a,0,b}
	end
	]]
end

return state