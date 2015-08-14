--local level = {}
localsd 
local upgrade = require('Game/upgrade')
function level.load()
	level.number = 1 --not reloaded
	level.playerLives = 5 -- not reloaded
	level.cycleEnemies = true

	STATE.player.lives = level.playerLives

	level.killThreshold = 20

	level.maxEnemySize = 70
	level.minEnemySize = 20

	level.maxEnemySpeed = 120
	level.minEnemySpeed = 40

	level.enemyHealth = 1

	level.enemyMissileSlowdown = 2
	level.enemyMissileSpeed = 200

	level.enemyMissileColor = {254, 35,40}--{255,255,100} --not reloaded

	level.enemySpawnSlowdown = 1
	level.enemySpawnTimer = level.enemySpawnSlowdown

	level.enemySpawnRateSlowdown = 0.5
	level.enemySpawnRateTimer = level.enemySpawnRateSlowdown*2

	level.enemyMissileMotionSensor = -40

	level.killsToWin = 500 -- not reloaded
end

function level.update(dt)
	if STATE.player.levelKills >= level.killThreshold then
		--ENEMYSPAWNPOINT += 10
	    level.enemyMissileFire = true
	    if level.maxEnemySize > 20 then
	        level.maxEnemySize = level.maxEnemySize - 1
	    end
	    if level.minEnemySize > 15 then
	        level.minEnemySize = level.minEnemySize - 1
	    end
	    
	    if level.maxEnemySpeed < 6 then
	        level.maxEnemySpeed = level.maxEnemySpeed + 0.5
	    end
	    
	    if level.minEnemySpeed < 3 then
	        level.minEnemySpeed = level.minEnemySpeed + 0.5
	    end
	    
	    if level.enemyMissileSlowdown > 0.25 then
	    	level.enemyMissileSlowdown = level.enemyMissileSlowdown - 0.25
	    	if level.enemyMissileSlowdown < 0.25 then
	    		level.enemyMissileSlowdown = 0.25
	    	end
	    end

	    if level.enemyMissileSpeed < 800 then
	    	level.enemyMissileSpeed = level.enemyMissileSpeed + 20        
	    	level.enemyMissileMotionSensor = level.enemyMissileMotionSensor + 20
		end

		if level.enemyHealth < 8 then
			level.enemyHealth = level.enemyHealth + 1
		end	

		level.killThreshold = level.killThreshold + 20
	end

	level.enemySpawnRateTimer = level.enemySpawnRateTimer - dt
	if level.enemySpawnRateTimer <= 0 then
		level.enemySpawnRateTimer = level.enemySpawnRateSlowdown
		level.enemySpawnRateSlowdown = level.enemySpawnRateSlowdown + 0.125
		if level.enemySpawnSlowdown > 0.1 then
			level.enemySpawnSlowdown = level.enemySpawnSlowdown - 0.125
			if level.enemySpawnSlowdown < 0.1 then
				level.enemySpawnSlowdown = 0.1
			end
		end
	end

	if STATE.player.levelKills>= level.killsToWin then
		STATE.enemies = {}
		STATE.enemyMissiles = {}
		STATE.player.missiles = {}

		STATE.state = STATE.states.won
		return
	end

	level.enemySpawnTimer = level.enemySpawnTimer - dt
	if level.enemySpawnTimer <= 0 then
		level.enemySpawnTimer = level.enemySpawnSlowdown
		if #STATE.enemies + STATE.player.levelKills < level.killsToWin then
			table.insert(STATE.enemies, enemy.make{
										x=math.random(STATE.camera.x-STATE.camera.width/2,STATE.camera.x+STATE.camera.width/2)
										,y=-level.maxEnemySpeed*1.5
										,health = 1
										,missileSpeed=level.enemyMissileSpeed
										,fireDelay=level.enemyMissileSlowdown
										,health=level.enemyHealth
										,width=math.random(level.minEnemySize, level.maxEnemySize)
										,yspeed=math.random(level.minEnemySpeed, level.maxEnemySpeed)
										,firing=level.enemyMissileFire
											})
			local v = STATE.enemies[#STATE.enemies]
			v.loot = math.ceil((level.maxEnemySize+50 - v.drawBox.width + v.yspeed*2))+175
		end
	end

	if level.enemyMissileFire then
		for i,enemy in ipairs(STATE.enemies) do
			enemy.firing = enemy.drawBox:getLeft()-level.enemyMissileMotionSensor <= STATE.player.drawBox:getRight()
							and enemy.drawBox:getRight()+level.enemyMissileMotionSensor >= STATE.player.drawBox:getLeft() 
		end
	end

end

function level.onDeath()
	level.enemyMissileMotionSensor	= math.max(level.enemyMissileMotionSensor-4,-40)
	level.enemyMissileSpeed 		= math.max(level.enemyMissileSpeed-40,200)
	level.enemyMissileSlowdown		= math.min(level.enemyMissileSlowdown+0.05,2)
	level.enemySpawnSlowdown 		= math.min(level.enemySpawnSlowdown+0.025, 0.5)
	level.maxEnemySpeed 			= math.max(level.maxEnemySpeed-20,120)
	level.minEnemySpeed 			= math.max(level.minEnemySpeed-20,40)
    level.enemyHealth 				= math.max(level.enemyHealth-1,1)
       
    STATE.player.levelCash 			= math.max(STATE.player.levelCash-5000,0)  
end

function level.draw()
end


function level.drawToHud(x,y,width,height)
	love.graphics.setColor(255,255,255)
	love.graphics.print('Kills Left: ' .. STATE.level.killsToWin - STATE.player.levelKills,x,y)
end

function level.reload()
	STATE.player.lives = level.playerLives

	level.killThreshold = 20
	level.enemiesKilled = 0

	level.maxEnemySize = 70
	level.minEnemySize = 20

	level.maxEnemySpeed = 120
	level.minEnemySpeed = 40

	level.enemyHealth = 1

	level.enemyMissileSlowdown = 2
	level.enemyMissileSpeed = 200

	level.enemySpawnSlowdown = 1
	level.enemySpawnTimer = level.enemySpawnSlowdown

	level.enemySpawnRateSlowdown = 0.5
	level.enemySpawnRateTimer = level.enemySpawnRateSlowdown*2

	level.enemyMissileMotionSensor = -40
end


return level