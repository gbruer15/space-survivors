local level = {}


function level.load()
	level.killThreshold = 20
	level.enemiesKilled = 0

	level.maxEnemySize = 70
	level.minEnemySize = 20

	level.maxEnemySpeed = 120
	level.minEnemySpeed = 40

	level.enemyHealth = 1

	level.enemyMissileSlowdown = 2
	level.enemyMissileSpeed = 200

	level.enemyMissileColor = {255,255,100}

	level.enemySpawnSlowdown = 1
	level.enemySpawnTimer = level.enemySpawnSlowdown

	level.enemySpawnRateSlowdown = 0.5
	level.enemySpawnRateTimer = level.enemySpawnRateSlowdown*2
end

function level.update(dt)
	if level.enemiesKilled >= level.killThreshold then
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

		level.enemiesKilled = level.enemiesKilled + 20
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

	level.enemySpawnTimer = level.enemySpawnTimer - dt
	if level.enemySpawnTimer <= 0 then
		level.enemySpawnTimer = level.enemySpawnSlowdown
		table.insert(STATE.enemies, enemy.make{
									x=math.random(100,500)
									,health = 1



										})
	end

	if level.enemyMissileFire then
		for i,enemy in ipairs(level.enemies) do
			self.firing = enemy.drawBox:getLeft()-level.enemyMissileMotionSensor <= level.player.drawBox:getRight()
							and enemy.drawBox:getRight()+level.enemyMissileMotionSensor >= player.drawBox:getLeft() 
		end
	end

end

function level.draw()

end





return level