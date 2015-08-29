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
		if not missile:isHittingRectangle(STATE.camera:getRect()) then
			table.remove(STATE.player.missiles,i)
		else
			for j,e in ipairs(STATE.enemies) do
				if collision.polygons(missile:getPolygon(),e:getPolygon()) then--missile:isHittingRectangle(e.collisionBox:getRect()) then
					local found
					if missile.piercedList then
						for a,f in ipairs(missile.piercedList) do
							if e == f then
								found = true
								break
							end
						end
					end
					if not found then
						e.health = e.health - missile.damage
						print('collide')
						if e.hurtLoot then
							STATE.player.levelCash = STATE.player.levelCash + e.hurtLoot
							table.insert(STATE.tempTexts,tempText.make{	 x = missile.x
																		,y = missile.y
																		,yspeed = -40
																		,life = 1
																		,text = '+$' .. e.hurtLoot
																		,color={0,255,0}
							})
						end
						missile.pierce = missile.pierce - 1
						STATE.screenshake = STATE.screenshake+0.3
						if missile.pierce > 0 then
							table.insert(missile.piercedList,e)
						else
							table.remove(STATE.player.missiles,i)
							break
						end
					end
				end
			end
		end
	end
	for i=#STATE.enemies,1,-1 do
		local v = STATE.enemies[i]
		v:update(dt)

		if v.drawBox:getTop() >= STATE.camera.y + STATE.camera.height/2 then
			STATE.player.levelCash = math.max(STATE.player.levelCash - 50,0)
			table.insert(STATE.tempTexts,tempText.make{	 x = v.x
														,y = STATE.camera.y + STATE.camera.height/2 + math.random(-10,10)
														,yspeed = -40
														,life = 1
														,text = '-$50'
														,color={255,0,0}
							})
			if STATE.level.cycleEnemies then
				v.y = STATE.camera.y-STATE.camera.height/2-100
			else
				table.remove(STATE.enemies,i)
			end
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
		elseif collision.polygons(STATE.player:getPolygon(),v:getPolygon()) then--STATE.player.collisionBox:collideRectangle(v.collisionBox) then
			STATE.player:die()
		elseif v.drawBox:getLeft() > STATE.camera.x+STATE.camera.width/2 then
			v.x = STATE.camera.x-STATE.camera.width/2 - v.drawBox.width/2
			v.xspeed = math.abs(v.xspeed)
		elseif v.drawBox:getRight() < STATE.camera.x-STATE.camera.width/2 then
			v.x = STATE.camera.x+STATE.camera.width/2 + v.drawBox.width/2
			v.xspeed = -math.abs(v.xspeed)
		end
	end

	if not STATE.player.dead then
		for i=#STATE.enemyMissiles,1,-1 do
			local missile = STATE.enemyMissiles[i]
			missile:update(dt)
			if collision.polygons(STATE.player:getPolygon(),missile:getPolygon()) then--missile:isHittingRectangle(STATE.player.collisionBox:getRect()) then
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