local state = {}	

function state.load()

	state.levelButtons = {}

	local numberOfColumns = 4
	local width = 140
	local height = 130
	local hspace = 15
	local vspace = 20
	
	local startx = window.width/2 - ((width+hspace)*numberOfColumns-hspace)/2
	local x = startx
	local y = 90
	local curCol = 1

	for i=1,4 do
		table.insert(state.levelButtons, button.make{
										text=i
										,x=x
										,y=y
										,width=width
										,height=height
										,image=false
										,imagecolor={200,200,0,150}
										,textcolor={20,20,20}
									})
		curCol = curCol + 1
		x = x + width + hspace
		if curCol > numberOfColumns then
			y = y + height + vspace
			x = startx
			curCol = 1
		end
	end

	state.maxStarSpeed = 800
	state.minStarSpeed = 40
	state.initializeStarryBackground(500)

end

function state.update(dt)
	state.updateStarryBackground(dt)

	state.levelHover = false
	for i,b in ipairs(state.levelButtons) do
		b:update(dt)
		if b.hover then
			state.levelHover = i
		end
	end
end

function state.draw()
	state.drawStarryBackground()

	for i,b in ipairs(state.levelButtons) do
		b:draw()
	end
end

function state.keypressed(key)

end

function state.mousepressed(x,y,button)
	if state.levelHover then
		STATE = require("Game/States/game")
		STATE.load(state.levelHover)
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
	self.radius = 1
	return self
end

return state