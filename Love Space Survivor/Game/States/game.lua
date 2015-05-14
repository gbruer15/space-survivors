local state = {}

local enemy = require('Game/Enemy/enemy')
function state.load()
	state.states = {}
	state.states.intro = require("Game/States/playingStates/intro")
	state.states.playing = require("Game/States/playingStates/playing")
	state.states.dead = require("Game/States/playingStates/dead")

	state.state = state.states.intro

	for i,v in pairs(state.states) do
		v.load()
	end

	for i,v in pairs(state.states) do
		v.player = state.states.playing.player
	end

	state.level = require("Levels/level" .. state.state.player.currentLevel)
	state.level.load()
	state.level.player = state.state.player

	for i,v in pairs(state.states) do
		v.level = state.level
	end

	state.maxStarSpeed = 800
	state.minStarSpeed = 40
	state.initializeStarryBackground(500)

end

function state.update(dt)
	if state.state.update(dt) == 'start' then
		state.state = state.states.playing
	end

	if state.state.player.dead and state.state ~= state.states.dead then
		state.switchToDead()
	end

	state.updateStarryBackground(dt)
end

function state.draw()
	state.drawStarryBackground()
	state.state.draw()

	love.graphics.setColor(255,255,255)
	love.graphics.print('Cash: ' .. state.state.player.cash,0,0)
	love.graphics.print('Score: ' .. state.state.player.score,0,15)
end

function state.keypressed(key)
	if state.state.keypressed then
		state.state.keypressed(key)
	end
end

function state.mousepressed(x,y,button)
	if state.state.mousepressed then
		if state.state.mousepressed(x,y,button) == 'restart' then
			state.state = state.states.playing
			--state.state.player.dead = false
			state.state.load()

			for i,v in pairs(state.states) do
				v.player = state.states.playing.player
			end
		end
	end
end

function state.switchToDead() 
	state.state = state.states.dead
	state.state.enemies = state.states.playing.enemies or {}
	state.state.enemyMissiles = state.states.playing.enemyMissiles or {}
	state.state.playerMissiles = state.states.playing.playerMissiles or {}
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