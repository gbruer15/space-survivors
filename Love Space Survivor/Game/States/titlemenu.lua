local state = {}	
require'Game/piecewiseLaser'
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

	missiles = {}
end

function state.update(dt)
	state.updateStarryBackground(dt)

	for i,b in pairs(state.buttons) do
		b:update(dt)
	end
	for i,v in ipairs(missiles) do
		v:update(dt)
	end
end

function state.draw()
	state.drawStarryBackground()

	for i,b in pairs(state.buttons) do
		b:draw()
	end

	for i,v in ipairs(missiles) do
		v:draw()
	end
	--love.graphics.print(tostring(collision.pointPolygon(MOUSE.x,MOUSE.y,points)),10,10)

	points = {50,300}--,  100,300,  100,500,  50,500}
	love.graphics.setColor(255,0,0)
	--love.graphics.polygon('line',points)
	love.graphics.circle('fill', points[1], points[2], 2)
	if missiles[#missiles] and missiles[#missiles].done1 then
		--collision.polygons(points,missiles[#missiles]:getPolygon())
		local p = missiles[#missiles]:getPolygon()--{ 165,632,125,493.89655172414,125,309.13616480032,205,309.13616480032,205,493.89655172414}
		love.graphics.setColor(100,100,0)
		local ex
		local ey
		for i = 1, #p-3, 2 do
			ex = (p[i+2] - p[i])*100
			ey = (p[i+3] - p[i+1])*100
			love.graphics.line(p[i] - ex,p[i+1] - ey, p[i+2] + ex, p[i+3] + ey)
		end
		local n = #p
		ex = (p[n-1] - p[1])*100
		ey = (p[n] - p[2])*100
		love.graphics.line(p[1] - ex,p[2] - ey, p[n-1] + ex, p[n] + ey)

		for i = 1, #points-1,2 do
			love.graphics.print('{ ' .. points[i] .. ', ' .. points[i+1] .. ' } ' .. tostring(collision.pointPolygon(points[i],points[i+1], p)), 10,15 + 20*i)
			if collision.pointPolygon(points[i],points[i+1], p) then
				collision.pointPolygon(points[i],points[i+1], p, true)
			end
		end

		local lineCol, sx, sy = collision.lineLineSegment(points[1],points[2], points[1]+5, points[2]+5,
										p[5],p[6], p[7],p[8])
		local rayColl = collision.rayLineSegment(points[1],points[2], points[1]+5, points[2]+5,
										p[5],p[6], p[7],p[8], true, 1)
				
		love.graphics.setColor(255,255,255)
		--love.graphics.print(tostring(rayColl) .. ' col?: ' .. tostring(lineCol) .. ' sx:' .. tostring(sx) .. ' sy:' .. tostring(sy)
--			, 100,50)
		local t = {}
		t.ox = p[3]
		t.oy = p[4]
		t.px = p[5]
		t.py = p[6]
		t.ax = points[1]
		t.ay = points[2]
		t.bx = points[1] + 5
		t.by = points[2] + 5
		l = 0
		for i,v in pairs(t) do
			l = l + 1
			--love.graphics.print(i .. ': ' .. v, 50, l*18+60)
		end
		
		--love.graphics.polygon('line',p)
	end
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
  elseif key == 'o' then
    doubleDebug = not doubleDebug
    print(tostring(myDebug) .. ' ' .. tostring(doubleDebug))
	elseif key == 'y' then
		table.insert(missiles,piecewiseLaser.make{
											x= MOUSE.x
											,y=MOUSE.y
											,speed=480
											,angle= -math.pi/2--math.random(-1,1)*math.pi/6 - math.pi/2
											,Image = images.greenLaser
											,TopImage = images.greenLaserTop
											,MiddleImage = images.greenLaserMiddle
											,BottomImage = images.greenLaserBottom
											,width = 80
											,type = 'mega'
										}
									)
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