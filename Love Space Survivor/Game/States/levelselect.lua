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


	local levelFiles = love.filesystem.getDirectoryItems('Levels')
	for i,file in pairs(levelFiles) do
		if file:sub(1,5) == 'level' and file:sub(-4) == '.lua' then
			local n = tonumber(file:sub(6,-5))
			if n then
				if n == math.floor(n) then
					state.levelButtons[n] = button.make{
										text=n
										,x=startx+(width+hspace)*((n-1)%numberOfColumns)
										,y=90 + (height+vspace)*math.floor((n-1)/numberOfColumns)
										,width=width
										,height=height
										,image=false
										,imagecolor={200,200,0,150}
										,textcolor={20,20,20}
									}
				else
					print('Level ' .. n .. " skipped because it's not an integer.")
				end

			else
				print('Level not recognized: ' .. file .. ' because "' .. file:sub(6,-5) .. '" is not a level number')
			end
		else
			print('"' .. file:sub(1,5) .. '" ~= "level" or "' .. file:sub(-4) .. ' ~= ".lua"')
		end
	end

	state.maxStarSpeed = 800
	state.minStarSpeed = 40
	state.initializeStarryBackground(500)

end

function state.update(dt)
	state.updateStarryBackground(dt)

	state.levelHover = false
	for i,b in pairs(state.levelButtons) do
		b:update(dt)
		if b.hover then
			state.levelHover = i
		end
	end
end

function state.draw()
	state.drawStarryBackground()

	for i,b in pairs(state.levelButtons) do
		b:draw()
	end
end

function state.keypressed(key)
	if key == ' ' then
		STATE = require("Game/States/game")
		STATE.load(1)
	end
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