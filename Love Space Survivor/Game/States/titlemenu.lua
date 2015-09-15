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

	love.graphics.setColor(0,0,255)


	local points = {}
	points[1] = -100
	points[2] = -200

	points[3] = 200
	points[4] = 150

	points[5] = 220
	points[6] = 250

	points[7] = 110
	points[8] = 500

	love.graphics.polygon('fill',points)
	--arc = {25,300,100,-math.pi/2,math.pi/2}
	--love.graphics.arc('fill',unpack(arc))


	love.graphics.setColor(255,255,255)

	--love.graphics.print(tostring(collision.pointPolygon(MOUSE.x,MOUSE.y,points)),10,10)


	local p = {858.5,93.477216575782}
	points = {0,0,  100,0,  100,500,  0,500}--{280.07602339181,-37.464670948157,309.92397660819,-37.464670948157,309.92397660819,32.067492794533,280.07602339181,32.067492794533}

	love.graphics.setColor(0,0,255)
	love.graphics.polygon('line',points)

	love.graphics.setColor(255,255,255)
	love.graphics.circle('fill',p[1],p[2],2)

	love.graphics.print(tostring(collision.pointPolygon(MOUSE.x,MOUSE.y,points)),10,25)
	love.graphics.print(MOUSE.x..','..MOUSE.y,10,40)

	love.graphics.setColor(255,0,0)
	love.graphics.line(0,0, MOUSE.x, MOUSE.y)
	--love.graphics.print(tostring(collision.lineLineSegment(0,0,MOUSE.x,MOUSE.y,points[1],points[2],points[3],points[4])),10,25)
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
	self.radius = 1--math.ceil( (self.speed-state.minStarSpeed)/(state.maxStarSpeed-state.minStarSpeed) *2 )
	return self
end

return state