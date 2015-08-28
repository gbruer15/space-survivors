local level = {}

local upgrade = require('Game/upgrade')
function level.load()
	level.number = 5 
	level.playerLives = 5
	STATE.player.lives = level.playerLives

	level.cycleEnemies = false

	level.enemyMissileColor = {254, 35,40}--{255,255,100}

	level.enemyMissileMotionSensor = 400
	level.enemyMissileFire = true

	level.maxBossHealth = 1000
	level.maxBossSpeed = 400

	level.bossSpeedChangeSlowdown = 0.25
	level.bossSpeedChangeTimer = 7.5

	level.boss = enemy.make{
							Image=images.boss
							,width= STATE.camera.width/3
							,firing=true
								}
	function level.boss:fireMissile()
		local left = self.drawBox:getLeft()
		local spacing = self.drawBox.width/4
		for i = 1,3 do
			table.insert(STATE.enemyMissiles,laser.make{
											x=left+spacing*i
											,y=self.drawBox:getBottom() - 3
											,speed=level.enemyMissileSpeed
											,angle=math.pi/2
										})
		end
	end

	level.reload()

	level.onDeath()
end


function level.reload()
	level.enemyHealth = 1
	level.killThreshold = 20
	level.enemyMissileSlowdown = 0.5
	level.enemyMissileSpeed = 200


	level.enemySpawnSlowdown = 1.875
	level.enemySpawnTimer = 12.5

	level.bossMissileFireSlowdown = 0.5

	level.boss.health = level.maxBossHealth
	level.boss.y = -150
	level.boss.x = STATE.camera.width/2
	level.boss.yspeed = 40
	level.boss.fireDelay = 2.5
	level.boss.fireCountdown = 10
end

function level.onDeath()
	table.insert(STATE.enemies,level.boss)
end

function level.update(dt)
	if STATE.player.levelKills >= level.killThreshold and false then
		--ENEMYSPAWNPOINT += 10
	    
	    if level.maxEnemySpeed < 6 then
	        level.maxEnemySpeed = level.maxEnemySpeed + 0.5
	    end
	    
	    if level.minEnemySpeed < 3 then
	        level.minEnemySpeed = level.minEnemySpeed + 0.5
	    end

		if level.enemyHealth < 8 then
			level.enemyHealth = level.enemyHealth + 1
		end

		level.killThreshold = level.killThreshold + 20
	end

	if level.boss.health <= 0 then
		STATE.enemies = {}
		STATE.enemyMissiles = {}
		STATE.player.missiles = {}

		STATE.state = STATE.states.won
		return
	end

	level.bossSpeedChangeTimer = level.bossSpeedChangeTimer - dt
	if level.bossSpeedChangeTimer <= 0 then
		level.bossSpeedChangeTimer = level.bossSpeedChangeSlowdown
		level.boss.xspeed = math.random(-level.maxBossSpeed,level.maxBossSpeed)
		level.boss.yspeed = math.random(-level.maxBossSpeed,level.maxBossSpeed)
	end

	if level.boss.drawBox:getTop() > 175 then
		level.boss.yspeed = -math.abs(level.boss.yspeed)
	elseif level.boss.drawBox:getTop() < -30 then
		level.boss.yspeed = math.abs(level.boss.yspeed)
	end

	if level.boss.drawBox:getLeft() < -50 then
		level.boss.xspeed = math.abs(level.boss.xspeed)
	elseif level.boss.drawBox:getRight() > STATE.camera.width+50 then
		level.boss.xspeed = -math.abs(level.boss.xspeed)
	end

	level.bossLoot = math.floor(.3*(level.boss.health/level.maxBossHealth)*500+50)
	level.boss.hurtLoot = level.bossLoot
    if level.boss.health > level.maxBossHealth*3/4 then
        level.enemySpawnSlowdown = 1.375
        level.boss.fireDelay = 0.625
        level.enemyMissileSpeed = 160
        level.maxBossSpeed = 400
    elseif level.boss.health > level.maxBossHealth/2 then
        level.enemySpawnSlowdown = 1.075
        level.boss.fireDelay = 0.45
        level.enemyMissileSpeed = 240
        level.maxBossSpeed = 560
    elseif level.boss.health > level.maxBossHealth/4 then
        level.enemySpawnSlowdown = 0.675
        level.boss.fireDelay = 0.275
        level.enemyMissileSpeed = 320
        level.maxBossSpeed = 720
    else
        level.enemySpawnSlowdown = 0.35
        level.boss.fireDelay = 0.1
        level.enemyMissileSpeed = 400
        level.maxBossSpeed = 880
    end

	level.enemySpawnTimer = level.enemySpawnTimer - dt
	if level.enemySpawnTimer <= 0 then
		level.enemySpawnTimer = level.enemySpawnSlowdown
		local left = level.boss.drawBox:getLeft()
		local bottom = level.boss.drawBox:getBottom()
		local spacing = level.boss.drawBox.width/5
		local enemyWidth = 30
		for i=1,4 do
			level.spawnEnemy(left+i*spacing,bottom,enemyWidth,80)
		end
	end
end

function level.draw()
end

function level.drawToHud(x,y,width,height)
	love.graphics.setColor(30,30,30)
	love.graphics.rectangle('fill',x,y,width,height)

	love.graphics.setColor(225,0,0)
	local padding = 5
	local healthWidth = math.ceil((width-padding*2)*level.boss.health/level.maxBossHealth)
	love.graphics.rectangle('fill',x + padding, y+padding ,healthWidth,height-padding*2)
end

function level.spawnEnemy(x,y,width,yspeed)
	table.insert(STATE.enemies, enemy.make{
										x = x or math.random(STATE.camera.x-STATE.camera.width/2,STATE.camera.x+STATE.camera.width/2)
										,y = y or -level.maxEnemySpeed*1.5
										,missileSpeed = level.enemyMissileSpeed
										,fireDelay = level.enemyMissileSlowdown
										,health = level.enemyHealth
										,width = width or math.random(level.minEnemySize, level.maxEnemySize)
										,yspeed = yspeed or math.random(level.minEnemySpeed, level.maxEnemySpeed)
										,firing= level.enemyMissileFire
											})
end


return level