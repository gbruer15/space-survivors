local state = {}	

function state.load()

	state.buttons = {}

	state.buttons.play = button.make{
										text='play'
										,centerx=window.width/2
										,y=window.height/2-50
										,image=false
										,imagecolor={200,200,0,150}
										,textcolor={20,20,20}
									}

	state.maxStarSpeed = 800
	state.minStarSpeed = 40
	state.initializeStarryBackground(500)

end

function state.update(dt)
	state.updateStarryBackground(dt)

	for i,b in pairs(state.buttons) do
		b:update(dt)
	end
end

function state.draw()
	state.drawStarryBackground()

	for i,b in pairs(state.buttons) do
		b:draw()
	end
	--love.graphics.print(tostring(collision.pointPolygon(MOUSE.x,MOUSE.y,points)),10,10)

--[[
	local p = {858.5,93.477216575782}
	points = {0,0,  100,0,  100,500,  0,500}--{280.07602339181,-37.464670948157,309.92397660819,-37.464670948157,309.92397660819,32.067492794533,280.07602339181,32.067492794533}

	point = {32.269177966444,464.24539153521}
	poly = { 8,405.47850919871,10.5,411.72581523319,10.5,440.87991006078,8,447.12721609526,5.5,440.87991006078,5.5,411.72581523319}
	
	p2 = {8,405.47850919871,10.5,411.72581523319,10.5,440.87991006078,8,447.12721609526,5.5,440.87991006078,5.5,411.72581523319}
	p1 = {14.955195013207,469.82014389641,17.452315492359,476.71256499754,19.691430903555,477.92887460362,32.269177966444,464.24539153521,44.828496095907,477.92887460362,47.150541707517,476.71256499754,49.610804319818,469.82014389641,52.17242606596,476.6112058637,46.606888171466,479.8639126133,50.329532723412,483.96435030047,45.031214363587,483.96435030047,43.151463154188,481.87266635667,39.410389668816,485.58609644191,32.269177966444,488.1108603212,25.284612198188,485.58609644191,21.469822979114,481.87266635667,19.525570502726,483.96435030047,14.162750875912,483.96435030047,17.940682228135,479.8639126133,12.458074534055,476.6112058637}


	love.graphics.setColor(0,0,255)
	love.graphics.polygon('line',p1)
	love.graphics.setColor(0,255,255)
	love.graphics.polygon('line', p2)

	love.graphics.setColor(255,0,0)
	love.graphics.circle('line', point[1],point[2],2)

	love.graphics.setColor(255,255,255)
	love.graphics.circle('fill',p[1],p[2],2)

	love.graphics.print(tostring(collision.pointPolygon(point[1],point[2],poly)),100,25)
	love.graphics.print(MOUSE.x..','..MOUSE.y,10,40)
--]]
	--love.graphics.setColor(255,255,0)
	--love.graphics.line(0,0, MOUSE.x, MOUSE.y)
	--love.graphics.print(tostring(collision.polygons(p1,p2)),10,60)
	--local b, angle = collision.pointArc(MOUSE.x,MOUSE.y,unpack(arc))
	--love.graphics.print(tostring(b) .. '\n'.. tostring(angle and angle/math.pi*180),10,10)
	--love.graphics.print(MOUSE.x .. ' ' .. MOUSE.y, 10,50)
end

function state.keypressed(key)
	if key == ' ' then
		STATE = require("Game/States/levelselect")
		STATE.load()
	end
end

function state.mousepressed(x,y,button)
	if state.buttons.play.hover then
		STATE = require("Game/States/levelselect")
		STATE.load()
	end
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
			state.stars[i] = state.spawnStar(v.y - v.radius - window.height)
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
	self.radius = 1--math.ceil( (self.speed-state.minStarSpeed)/(state.maxStarSpeed-state.minStarSpeed) *2 )
	return self
end

return state