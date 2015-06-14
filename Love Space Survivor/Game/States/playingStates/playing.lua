local state = {}

enemy = require('Game/Enemy/enemy')
local tempText = require('1stPartyLib/display/tempText')
function state.load()
end

function state.update(dt)
	STATE.hud:update(dt)
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
					STATE.screenshake = STATE.screenshake+0.3
					break
				end
			end
		end
	end
	for i=#STATE.enemies,1,-1 do
		local v = STATE.enemies[i]
		v:update(dt)

		if v.drawBox:getTop() >= STATE.camera.y + STATE.camera.height/2 then
			--table.remove(STATE.enemies,i)
			STATE.player.levelCash = math.max(STATE.player.levelCash - 50,0)
			table.insert(STATE.tempTexts,tempText.make{	 x = v.x
														,y = STATE.camera.y + STATE.camera.height/2 + math.random(-10,10)
														,yspeed = -40
														,life = 1
														,text = '-$50'
														,color={255,0,0}
							})
			v.y = STATE.camera.y-STATE.camera.height/2-100
		elseif v.health <= 0 then
			STATE.player.levelCash = STATE.player.levelCash + v.loot
			STATE.player.levelScore = STATE.player.levelScore + v.points
			STATE.player.levelKills = STATE.player.levelKills + 1

			STATE.player.totalKills = STATE.player.totalKills + 1
			table.remove(STATE.enemies,i)
			table.insert(STATE.tempTexts,tempText.make{	 x = v.x
														,y = v.y
														,yspeed = -40
														,life = 1
														,text = '+$' .. v.loot
														,color={0,255,0}
							})
		elseif STATE.player.collisionBox:collideRectangle(v.collisionBox) then
			STATE.player:die()
		end
	end

	if not STATE.player.dead then
		for i=#STATE.enemyMissiles,1,-1 do
			local missile = STATE.enemyMissiles[i]
			missile:update(dt)
			if missile:isHittingRectangle(STATE.player.collisionBox:getRect()) then
				STATE.player:die()
			elseif not missile:isHittingRectangle(STATE.camera.getRect()) then
				table.remove(STATE.enemyMissiles,i)
			end
		end
	end

	STATE.level.update(dt)
end

function state.draw()
	
end

function state.keypressed(key)
	if key == 'p' then
		STATE.paused = true
	end
end

function state.mousepressed(x,y,button)
	if collision.pointRectangle(x,y,STATE.hud.x,STATE.hud.y,STATE.hud.width,STATE.hud.height) then
		STATE.hud:mousepressed(x,y,button)
	else
		STATE.player:mousepressed(x,y,button)
	end
end

return state