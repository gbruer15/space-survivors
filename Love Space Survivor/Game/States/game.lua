local state = {}

local enemy = require('Game/Enemy/enemy')
local upgrade = require('Game/upgrade')
local hud = require('Game/hud')
local button = require('1stPartyLib/display/button')
function state.load()
	state.states = {}
	state.states.intro = require("Game/States/playingStates/intro")
	state.states.playing = require("Game/States/playingStates/playing")
	state.states.paused = require("Game/States/playingStates/paused")
	state.states.dead = require("Game/States/playingStates/dead")


	--variables used by states	
	state.upgrades = {}

	table.insert(state.upgrades,upgrade.make{
											name = 'Missile Attack'
											,description = 'Upgrade missile attack power'
											,costFunction = function(v,c) return c+1000 end
		})


	state.hud = hud.make{
						x=window.width-200
						,y=0
						,width = 200
						,height=window.height
						}

	state.camera = require("1stPartyLib/display/camera").make{
												width=window.width-state.hud.width
												,height=window.height
											}

	state.player = require("Game/Player/player").make()
	
	state.enemies = {}
	state.enemyMissiles = {}

	state.level = require("Levels/level" .. state.player.currentLevel)

	state.paused = false
	-------------------------

	state.level.load()


	state.state = state.states.intro

	for i,v in pairs(state.states) do
		v.load()
	end

	

	state.maxStarSpeed = 800
	state.minStarSpeed = 40
	state.initializeStarryBackground(500)

end

function state.update(dt)
	if state.state.update(dt) == 'start' then
		state.state = state.states.playing
	end


	if state.player.dead and state.state ~= state.states.dead then
		state.switchToDead()
	elseif STATE.paused then
		state.state = state.states.paused
	elseif not state.player.dead then
		state.updateStarryBackground(dt)
	end
end

function state.draw()
	state.drawStarryBackground()

	love.graphics.setColor(255,255,255)
	state.player:draw()

	love.graphics.setColor(255,0,0)
	for i,v in ipairs(state.player.missiles) do
		v:draw()
	end

	love.graphics.setColor(255,255,255)
	for i,v in ipairs(state.enemies) do
		v:draw()
	end

	love.graphics.setColor(state.level.enemyMissileColor)
	for i,v in ipairs(state.enemyMissiles) do
		v:draw()
	end	

	state.state.draw()

	state.hud:draw()
end

function state.keypressed(key)
	if state.state.keypressed then
		state.state.keypressed(key)
	end
end

function state.mousepressed(x,y,button)
	if state.state.mousepressed then
		if state.state.mousepressed(x,y,button) == 'keep playing' then
			
		end
	end
end

function state.switchToDead() 
	state.state = state.states.dead
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
		if v.y - v.radius > state.camera.y + state.camera.height then
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
	self.x = math.random(state.camera.x-state.camera.width/2,state.camera.x + state.camera.width/2)
	self.y = y or -10
	self.speed = math.random(state.minStarSpeed,state.maxStarSpeed)
	self.radius = 1
	return self
end

return state