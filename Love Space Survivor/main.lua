love.window.setFullscreen(true,'desktop')

love.graphics.setBackgroundColor(0,0,0)

love.graphics.clear()

love.graphics.setColor(10,210,150)
love.graphics.rectangle("fill",25,25,100,15)

love.graphics.setColor(0,0,0)
love.graphics.printf("Loading Space Survivors",25,26,100,'center')
	
love.graphics.present()


io.stdout:setvbuf("no")

function requireDirectory(dirPath, isRecursive)
	local dirItems = love.filesystem.getDirectoryItems(dirPath)
	for i,v in ipairs(dirItems) do
		if love.filesystem.isFile(dirPath .. '/' .. v) and string.sub(v,string.len(v)-3) == '.lua' then
			require(dirPath .. '/' .. string.sub(v,1,string.len(v)-4))
			print("Required " .. dirPath .. '/' .. string.sub(v,1,string.len(v)-4))
		elseif love.filesystem.isDirectory(dirPath .. '/' .. v) then
			if isRecursive then
				requireDirectory(dirPath .. '/' .. v,true)
			else
				print("Skipped " .. dirPath .. '/' .. v ..  " because we're not doing it recursively")
			end
		else
			print("Is not a file or directory?? : " .. dirPath .. '/' .. v )
		end
	end
end
local path
LUA_PATH, path = "?;?.lua",LUA_PATH
--requireDirectory("game") ---not recursive because Enemies are loaded after enemies.load is called
--requireDirectory("lib", true)
LUA_PATH, path = path, LUA_PATH


function love.load(arg)
  print('hat')
  if arg[#arg] == "-debug" then require("mobdebug").start() myDebug = true end
  if myDebug then require("mobdebug").off() end
  print('hat2')
  
	IMAGES_PATH = 'Assets/Images/'
	GOOD_IMAGES_PATH = 'Assets/GoodImages/'
	GOOD_SOUNDS_PATH = 'Assets/GoodSounds/'
	lovefunctions = {'keypressed','keyreleased','mousepressed','mousereleased'}
	require('1stPartyLib/physics/collision')
	require('resources')
	require('1stPartyLib/utilities/math')
	requireDirectory('1stPartyLib/display')
	
	window = {}
	window.width, window.height = love.graphics.getDimensions()
	window.fullscreen = false

	MOUSE = {}
	MOUSE.x, MOUSE.y = love.mouse.getPosition()

	STATE = require('Game/States/titlemenu') --require("Game/States/game")
	STATE.load()
	--resources.load()
	--music.fight.music:play()
	
	--love.mouse.setVisible(false)
	--lovefunctions = {"mousepressed","mousereleased","keypressed","keyreleased"}
	
	--states.loadingscreen.load('titlemenu',1.5)
	--states.empty.load()
	
end

function love.update(dt)

	MOUSE.x, MOUSE.y = love.mouse.getPosition()
	STATE.update(dt)

	
	love.window.setTitle(love.timer.getFPS())

	if QUIT then
		love.event.quit()
	end
end


function love.draw()
	STATE.draw()
	--[
	--states[state].draw()	

	------Draw Cool Cursor Thing--------
	local x,y = love.mouse.getPosition()

	love.graphics.push()
	love.graphics.translate(x,y)
	love.graphics.scale(0.5, 0.5)
	love.graphics.translate(-x, -y)

	love.mouse.setVisible(false)
	

	local ang = (love.timer.getTime()*5 and false) or love.timer.getTime()+ math.sin(love.timer.getTime())*5
	
	--ang = math.pi/12
	
	local colorChange = {(math.sin(ang)+1)*127,(math.cos(ang/2)+1)*127,math.sin(love.timer.getTime())*100+10, 0}
	--love.graphics.setColor(colorChange)
	--local xd,yd = (40*math.cos(ang)),(40*math.cos(ang/2))
	local xd,yd = math.abs(20*math.cos(ang)),math.abs(20*math.cos(ang/2))
	xd = math.max(3, xd)
	yd = math.max(3, yd)

	drawBlur.ellipse(x,y,xd,yd,ang,nil,15, {255,255,255},colorChange)
	love.graphics.setColor(255,255,255)
	love.graphics.ellipse("fill",x,y,xd,yd,ang)
	drawBlur.ellipse(x,y,xd-math.min(10,xd),yd-math.min(10,yd/2),ang,nil,math.min(5,yd,xd), {0,0,0,0},{255,255,255})
	love.graphics.setColor(0,0,0)
	love.graphics.ellipse("fill",x,y,xd-math.min(10,xd/2),yd-math.min(10,yd/2),ang)
	------------------------------------------------------------------------------
	
	love.graphics.setColor(255,255,255,100)
	love.graphics.circle("fill",x,y,2)

	love.graphics.pop()
--]]
	--[[
	love.graphics.setColor(0,0,0)
	love.graphics.rectangle("fill",0,0,window.width,window.height)
	
	local width,height = 50,50
	local blurwidth = 30
	
	love.graphics.setColor(200,200,200)
	love.graphics.rectangle("fill",window.width/4-width/2,window.height/2-height/2,width,height)
	love.graphics.rectangle("fill",3*window.width/4-width/2,window.height/2-height/2,width,height)
	
	drawBlur.rectangleInversePower(window.width/4-width/2,window.height/2-height/2,width,height, blurwidth,{255,255,0},{255,255,0,0},0.5)
	drawBlur.rectangleInversePower(3*window.width/4-width/2,window.height/2-height/2,width,height, blurwidth,{255,255,0},{255,255,0,0},-0.1)
	--]]
	
	
	
end


function love.keypressed(key)
	if key == '1' then
		music.first:setPitch(music.first:getPitch()/2)
	elseif key == '2' then
		music.first:setPitch(music.first:getPitch()*2)
	end
	if STATE.keypressed then
		STATE.keypressed(key)
	end
	if key == 'escape' then
		love.event.quit()
	elseif key == 'f' then
		if love.window.setFullscreen(not window.fullscreen,'desktop') then
			window.width, window.height = love.graphics.getDimensions()
			window.fullscreen = not window.fullscreen
		end
	end
end	

function love.keyreleased(key)
	if STATE.keyreleased then
		STATE.keyreleased(key)
	end
end

function love.mousepressed(x,y,b)
	if STATE.mousepressed then
		STATE.mousepressed(x,y,b)
	end
end

function love.mousereleased(x,y,b)
	if STATE.mousereleased then
		STATE.mousereleased(x,y,b)
	end
end

function love.textinput(text)
	if STATE.textinput then
		STATE.textinput(text)
	end
	--TYPED = TYPED .. text
end


function love.quit()
	--execute this on quit
end


function love.processEvents()
	if love.event then
		love.event.pump()
		for e,a,b,c,d in love.event.poll() do
			if e == "quit" then
				if not love.quit or not love.quit() then
					if love.audio then
						love.audio.stop()
					end
					QUIT = true
				end
			end
			love.handlers[e](a,b,c,d)
		end
	end
end

function love.run()
    math.randomseed(os.time())
    math.random() math.random()

    if love.load then love.load(arg) end

    -- FPS cap
	min_dt = 1/60
	next_time = love.timer.getTime()

    local dt = 0
    local lastDt = dt
    local maxDt = 1/30
    -- Main loop time.
    while not QUIT do	
    	--  FPS cap
		next_time = next_time + min_dt	

        love.processEvents()

        -- Update dt, as we'll be passing it to update
        love.timer.step()
        dt,lastDt = love.timer.getDelta(),dt

        --print(dt/maxDt)
        -- Call update and draw
        if dt < maxDt or dt/lastDt < 1.5 or true then
      if myDebug then dt = 1/60 end
			love.update(dt)
			
			love.graphics.clear()
			love.draw()
			
			love.graphics.present()
		else
			dt = lastDt
			print('skip')
		end

		-- FPS cap
		local cur_time = love.timer.getTime()
		if next_time <= cur_time then
			next_time = cur_time
		end
		love.timer.sleep(1*(next_time - cur_time))
    end
end


function love.filesystem.removeDirectory(directory)
	local files = love.filesystem.getDirectoryItems(directory)

	for i,v in ipairs(files) do
		local ok
		local path = directory .. '/' .. v
		if love.filesystem.isFile(path) then
			ok = love.filesystem.remove(path)
		elseif love.filesystem.isDirectory(path) then
			ok = love.filesystem.removeDirectory(path)
		end
		if not ok then
			return ok, tostring(ok) .. "  " .. path
		end
	end

	return love.filesystem.remove(directory)
end

local function error_printer(msg, layer)
	print((debug.traceback("Error: " .. tostring(msg), 1+(layer or 1)):gsub("\n[^\n]+$", "")))
end
 
 
function love.errhand(msg)
	local success,err = pcall(love.customErrorHandler,msg)

	if not success then 
		print('\nLove Error Handler error: ' .. tostring(err)) 
		return
	end
end

function love.customErrorHandler(msg)
	msg = tostring(msg)
 	
	error_printer(msg, 2)
 	
	if not love.window or not love.graphics or not love.event then
		return
	end
 
	if not love.graphics.isCreated() or not love.window.isCreated() then
		local success, status = pcall(love.window.setMode, 800, 600)
		if not success or not status then
			return
		end
	end

	-- Reset state.
	if love.mouse then
		love.mouse.setVisible(true)
		love.mouse.setGrabbed(false)
	end
	if love.joystick then
		-- Stop all joystick vibrations.
		for i,v in ipairs(love.joystick.getJoysticks()) do
			v:setVibration()
		end
	end
	if love.audio then love.audio.stop() end
	love.graphics.reset()

	local font = love.graphics.setNewFont(14)--math.floor(love.window.toPixels(14)))

	local sRGB = select(3, love.window.getMode()).srgb
	if sRGB and love.math then
		love.graphics.setBackgroundColor(love.math.gammaToLinear(89, 157, 220))
	else
		love.graphics.setBackgroundColor(89, 157, 220)
	end

	love.graphics.setColor(255, 255, 255, 255)
 
	local trace = debug.traceback()

	love.graphics.clear()
	love.graphics.origin()
 
	local err = {}
 
	table.insert(err, "Error\n")
	table.insert(err, msg.."\n\n")
 
	for l in string.gmatch(trace, "(.-)\n") do
		if not string.match(l, "boot.lua") then
			l = string.gsub(l, "stack traceback:", "Traceback\n")
			table.insert(err, l)
		end
	end
 
	local p = table.concat(err, "\n")
 
	p = string.gsub(p, "\t", "")
	p = string.gsub(p, "%[string \"(.-)\"%]", "%1")
 
 	local state = createErrorHandlerState()

	state.load()
	state.errorMessage = p
	love.graphics.setBackgroundColor(0,0,0)
	if not love.timer then
		while not quit do
			love.event.pump()
	 
			for e, a, b, c in love.event.poll() do
				if e == "quit" then
					return
				end
				if e == "keypressed" and a == "escape" then
					return
				end
			end

	 		state.update(1/60)

	 		love.graphics.clear()

			state.draw()

	 		love.graphics.present()
		end 
	else ---Really nice looking loop with time
		-- FPS cap
		min_dt = 1/60
		next_time = love.timer.getTime()

	    local dt = 0
	    local lastDt = dt
	    local maxDt = 1/30
		while not quit do
			love.event.pump()
	 
			for e, a, b, c in love.event.poll() do
				if e == "quit" then
					return
				end
				if e == "keypressed" and a == "escape" then
					return
				end
			end

	 		love.timer.step()
	        dt,lastDt = love.timer.getDelta(),dt
	        -- Call update and draw

	        if dt < maxDt or dt/lastDt < 1.5 then
				state.update(dt)

		 		love.graphics.clear()

				state.draw()

		 		love.graphics.present()
			end		

			-- FPS cap
			local cur_time = love.timer.getTime()
			if next_time <= cur_time then
				next_time = cur_time
			end
			love.timer.sleep(1*(next_time - cur_time))
		end 
	end
end
--]]

function createErrorHandlerState()
	local state = {}

	function state.load()
		state.maxStarSpeed = 800
		state.minStarSpeed = 40
		state.initializeStarryBackground(500)
	end
 	function state.update(dt)
 		state.updateStarryBackground(dt)
 	end

 	function state.draw()
 		state.drawStarryBackground()

		local pos = 70--love.window.toPixels(70)
		love.graphics.setColor(255,255,255)
		love.graphics.printf(state.errorMessage, pos, pos, love.graphics.getWidth() - pos)
 	end

	function state.initializeStarryBackground(n)
		state.stars = {}
		for i=1,n do
			table.insert(state.stars, state.spawnStar( math.floor(i/n*window.height) ))
		end
	end

	function state.updateStarryBackground(dt)
		for i,v in ipairs(state.stars) do
			v.y = v.y + v.speed*dt
			if v.y - v.radius > window.height then
				state.stars[i] = state.spawnStar()
			end
		end
	end

	function state.drawStarryBackground()		
		for i,v in ipairs(state.stars) do
			local n = 255*v.speed/state.maxStarSpeed
			love.graphics.setColor(n,n,n)
			love.graphics.circle('fill',v.x,v.y,v.radius)
		end
	end

	function state.spawnStar(y)
		local self = {}
		self.x = math.random(0,window.width)
		self.y = y or -10
		self.speed = math.random(state.minStarSpeed,state.maxStarSpeed)
		self.radius = 1
		return self
	end	
	return state
end