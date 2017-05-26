local state = {}	
function state.load()

	state.buttons = {}

	state.buttons.back = button.make{
										text='Back'
										,centerx=window.width/2
										,y=window.height-150
										,image=false
										,imagecolor={250,100,0,150}
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

	love.graphics.setColor(255,255,255, 50)
	love.graphics.setFont(fonts.basic[48])
	love.graphics.printf("Options Screen!!", 0, 100, window.width, 'center')

	for i,b in pairs(state.buttons) do
		b:draw()
	end
end

function state.keypressed(key)
	if key == 'space' then
		STATE = require("Game/States/titlemenu")
		STATE.load()
	end
end

function state.mousepressed(x,y,button)
	if state.buttons.back.hover then
		STATE = require("Game/States/titlemenu")
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