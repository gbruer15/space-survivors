local state = {}

local enemy = require('Game/Enemy/enemy')
local upgrade = require('Game/upgrade')
local hud = require('Game/hud')
local button = require('1stPartyLib/display/button')
local tempText = require('1stPartyLib/display/tempText')
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
											name = 'Switch weapon types'
											,value = 1
											,description = 'Crazy swirls or rectangles?'
											,costFunction = function(v,c) return v*500+2000 end
											,upgradeFunction = function() 
																state.player.fireSwirls = not state.player.fireSwirls
															end
											,isMaxedOutFunction = function() 
																return false
															end
		})
	table.insert(state.upgrades,upgrade.make{
											name = 'Number of Missiles'
											,value = 1
											,description = 'Upgrade number of missiles fired at a time'
											,costFunction = function(v,c) return v==1 and 5000 or v==2 and 10000
																		  or v == 3 and 25000 or 50000 end--v*500+5000 end
											,upgradeFunction = function() 
																state.player.missileType = state.player.missileType + 1
															end
											,isMaxedOutFunction = function() 
																return state.player.missileType >= #state.player.fireMissileFunctions
															end
		})
	table.insert(state.upgrades,upgrade.make{
											name = 'Missile Attack'
											,value = 1
											,description = 'Upgrade missile attack power'
											,costFunction = function(v,c) return v*500+1000 end
											,upgradeFunction = function() 
																state.player.missileDamage = state.player.missileDamage + 1
															end
											,isMaxedOutFunction = function() 
																return state.player.missileDamage >= state.level.enemyHealth
															end
		})
	table.insert(state.upgrades,upgrade.make{
											name = 'Missile Pierce'
											,value = 0
											,description = 'Upgrade missile pierce ability'
											,costFunction = function(v,c) return v*500+3000 end
											,upgradeFunction = function() 
																state.player.missilePierce = state.player.missilePierce + 1
															end
											,isMaxedOutFunction = function() 
																return state.player.missilePierce >= 4
															end
		})
	table.insert(state.upgrades,upgrade.make{
											name = 'Missile Speed'
											,value = 1
											,description = 'Upgrade missile speed'
											,costFunction = function(v,c) return v*1000+5000 end
											,upgradeFunction = function() 
																state.player.missileSpeed = state.player.missileSpeed + 40
															end
											,isMaxedOutFunction = function() 
																return state.player.missileSpeed >= 600
															end
		})
	table.insert(state.upgrades,upgrade.make{
											name = 'Missile Fire Rate'
											,value = 1
											,description = 'Upgrade missile fire rate'
											,costFunction = function(v,c) return v*500+1000 end
											,upgradeFunction = function() 
																state.player.fireDelay = math.max(state.player.fireDelay-0.1,state.player.fireDelay/1.5,0.05)
															end
											,isMaxedOutFunction = function()
																return state.player.fireDelay <= 0.05
															end
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

	state.tempTexts = {}
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

	state.player.currentLevel = levelNumber

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

	for i =#STATE.tempTexts,1,-1 do
		local v = STATE.tempTexts[i]
		v:update(dt)
		if v.destroy then
			table.remove(STATE.tempTexts,i)
		end
	end

	--(254, 35,40)
	--[[local t = love.timer.getTime()
	state.level.enemyMissileColor[1] = (254-180)*math.sin(t)^2 + 180
	state.level.enemyMissileColor[2] = (35-0)*math.sin(t)^2 + 0
	state.level.enemyMissileColor[3] = (40-0)*math.sin(t)^2 + 0
--]]
	state.screenshake = math.min(15,math.max(state.screenshake - dt, 0))
end

function state.draw()
	if state.screenshakeFlag then
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

	for i,v in ipairs(state.tempTexts) do
		v:draw()
	end

	if state.screenshakeFlag and state.screenshake > 0 then
		love.graphics.pop()
 	end

end

function state.keypressed(key)
	if key == 'l' then
		state.screenshake = state.screenshake + 2
	elseif key == 'j' then
		state.player.levelCash = state.player.levelCash + 500000

		state.player.fullauto = true
		state.player.fireDelay = 0.05

		state.player.missileType = #state.player.fireMissileFunctions
		state.player.missileSpeed = 600
		state.player.missileDamage = 1
		state.player.missilePierce = 4

		state.player.fireSwirls = true
	elseif key == 'm' then
		state.player.mouseControl = not state.player.mouseControl
	elseif key == 'i' then
		state.screenshakeFlag = not state.screenshakeFlag
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