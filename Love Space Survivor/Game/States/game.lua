local state = {}

local enemy = require('Game/Enemy/enemy')
local upgrade = require('Game/upgrade')
local hud = require('Game/hud')
local button = require('1stPartyLib/display/button')
function state.load(n)
	state.states = {}
	state.states.intro = require("Game/States/playingStates/intro")
	state.states.playing = require("Game/States/playingStates/playing")
	state.states.paused = require("Game/States/playingStates/paused")
	state.states.dead = require("Game/States/playingStates/dead")
	state.states.won = require("Game/States/playingStates/won")

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

	state.loadLevel(n)--state.player.currentLevel)

	state.paused = false
	-------------------------

	for i,v in pairs(state.states) do
		v.load()
	end

	state.maxStarSpeed = 800
	state.minStarSpeed = 40
	state.initializeStarryBackground(500)

	state.screenshake = 0
end

function state.loadLevel(levelNumber)
	state.level = require("Levels/level" .. levelNumber)
	state.level.load()

	state.player.levelKills = 0
	state.player.levelCash = 0
	state.player.levelScore = 0

	state.player.x = state.camera.x
	state.player.y = state.camera.y

	state.state = state.states.intro
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

	state.screenshake = math.min(15,math.max(state.screenshake - dt, 0))
end

function state.draw()
	if state.screenshake > 0 and now then
		love.graphics.push()
		if state.screenshake > 5 then
			local angle = math.min(state.screenshake-5,5)
			local x = window.width/2 + math.random(-angle,angle)
			local y = window.height/2 + math.random(-angle,angle)

			love.graphics.translate(x,y)
			love.graphics.rotate(math.random(-angle,angle)/140)
			love.graphics.translate(-x,-y)
		end

		love.graphics.translate(math.random(-state.screenshake,state.screenshake),math.random(-state.screenshake,state.screenshake))
		now = false
	elseif state.screenshake > 0 then
		love.graphics.push()
		local shake = state.screenshake/2
		if shake > 5 then
			local angle = math.min(shake-5,5)
			local x = window.width/2 + math.random(-angle,angle)
			local y = window.height/2 + math.random(-angle,angle)

			love.graphics.translate(x,y)
			love.graphics.rotate(math.random(-angle,angle)/140)
			love.graphics.translate(-x,-y)
		end

		love.graphics.translate(math.random(-shake,shake),math.random(-shake,shake))
		now = true
 	end
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

	if state.screenshake > 0 then
		love.graphics.pop()
 	end
end

function state.keypressed(key)
	if key == 'l' then
		state.screenshake = state.screenshake + 2
	end

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