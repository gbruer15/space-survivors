local state = {}

function state.load()
	state.hue = 0
	state.hueSpeed = 180--45
	state.countdown = 4

	state.buttons = {}
	print('a' .. STATE.player.currentLevel)
	state.nextLevelExists = love.filesystem.exists('Levels/level' .. STATE.player.currentLevel+1 .. '.lua')
	if state.nextLevelExists then
		state.buttons.nextLevel = button.make{
										text='Next Level!'
										,x=STATE.camera.x-100
										,y=STATE.camera.y+150
										,image=false
										,imagecolor={0,200,0,150}
										,textcolor={20,20,20}
									}
	else
		state.buttons.nextLevel = button.make{
										text='No Level!'
										,x=STATE.camera.x-100
										,y=STATE.camera.y+150
										,image=false
										,imagecolor={0,0,0}
										,textcolor={200,200,200}
									}
	end
	state.buttons.levelScreen = button.make{
										text='levelScreen'
										,x=STATE.camera.x+100
										,y=STATE.camera.y+150
										,image=false
										,imagecolor={200,0,0,150}
										,textcolor={20,20,20}
									}

	state.text = 'You won!'
end

function state.update(dt)
	state.hue = state.hue + state.hueSpeed*dt

	STATE.player.x, STATE.player.y = MOUSE.x, MOUSE.y
	if state.countdown then
		state.countdown = state.countdown - dt*1.5
		if state.countdown <= 0 then
			state.countdown = nil
			state.text = 'Ready for more?'
			state.hueSpeed = 0
			--add something here
		end
	else
		for i,b in pairs(state.buttons) do
			b:update(dt)
		end
	end	
end

function state.draw()

	love.graphics.setColor(state.getRgbFromH(state.hue))

	local rgb = state.getRgbFromH(state.hue)

	love.graphics.printf(state.text,STATE.camera.x-STATE.camera.width/2,STATE.camera.y,STATE.camera.width,'center')

	if not state.countdown then
		for i,b in pairs(state.buttons) do
			b:draw()
			love.graphics.setColor(100,100,100)
			outlines.basicOutline:draw(b.x,b.y,b.width,b.height,5)
		end
	end
end

function state.keypressed(key)
end

function state.mousepressed(x,y,button)
	if not state.countdown then
		if state.buttons.nextLevel.hover and state.nextLevelExists then
			STATE.player.currentLevel = STATE.player.currentLevel+1
			STATE.loadLevel(STATE.player.currentLevel)
		elseif state.buttons.levelScreen.hover then

		end
	end
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