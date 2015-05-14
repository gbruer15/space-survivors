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

	if level.enemyMissileFire then
		for i,v in 

	end
	if enemymissilefire:
	    i = 0
	    soundplayed = False
	    while i <= len(enemymissileslowdown)-1:
	        enemy = pygame.transform.scale(enemyImage, (enemywidth[i], int(round(enemywidth[i]*1.66666666666)))).get_rect()
	        enemy.centerx = enemyx[i]
	        enemy.top = enemyy[i]
	        
	        if enemy.left-ENEMYMISSILEMOTIONSENSOR <= player.right and enemy.right+ENEMYMISSILEMOTIONSENSOR >= player.left:
	            if enemymissileslowdown[i] <=0:
	                enemymissileslowdown[i] = ENEMYMISSILESLOWDOWN/movementchange
	                enemymissilex.append(enemy.centerx)
	                enemymissiley.append(enemy.bottom)
	                if enemymissilesoundeffectcountdown <= 0 and not soundplayed:
	                    enemymissilesoundeffect.play()
	                    enemymissilesoundeffectcountdown = (0/FPS)/movementchange
	                elif not soundplayed:
	                    enemymissilesoundeffectcountdown -= 1
	                soundplayed = True
	                
	            else:
	                enemymissileslowdown[i] -= 1
	        i += 1
               
end

function level.draw()

end





return level