local state = {}

enemy = require('Game/Enemy/enemy')
function state.load()
end

function state.update(dt)
	STATE.player:update(dt)

	for i=#STATE.player.missiles,1,-1 do
		local missile = STATE.player.missiles[i]
		missile:update(dt)
		if STATE.camera.isOffscreen(missile.x, missile.y) and STATE.camera.isOffscreen(missile.endX, missile.endY) then
			table.remove(STATE.player.missiles,i)
		else
			for j,e in ipairs(STATE.enemies) do
				if missile:isHittingRectangle(e.collisionBox:getRect()) then
					e.health = e.health - missile.damage
					table.remove(STATE.player.missiles,i)
					break
				end
			end
		end
	end
	for i=#STATE.enemies,1,-1 do
		local v = STATE.enemies[i]
		v:update(dt)

		if v.drawBox:getTop() >= STATE.camera.y + STATE.camera.height/2 then
			table.remove(STATE.enemies,i)
		elseif v.health <= 0 then
			STATE.player.cash = STATE.player.cash + v.loot
			STATE.player.score = STATE.player.score + v.points
			STATE.player.kills = STATE.player.kills + 1
			STATE.level.enemiesKilled = STATE.level.enemiesKilled + 1
			table.remove(STATE.enemies,i)
		elseif STATE.player.collisionBox:collideRectangle(v.collisionBox) then
			STATE.player.dead = true
		end
	end

	if not STATE.player.dead then
		for i,missile in ipairs(STATE.enemyMissiles) do
			missile:update(dt)
			if missile:isHittingRectangle(STATE.player.collisionBox:getRect()) then
				STATE.player.dead = true
			end
		end
	end

	STATE.level.update(dt)
end

function state.draw()
	
end

function state.keypressed(key)

end

function state.mousepressed(x,y,button)
	STATE.player:mousepressed(x,y,button)
	table.insert(STATE.enemies, enemy.make{x=math.random(100,500),health = 1,y=-80})
end

return state