local state = {}

require('Game/powerup')
enemy = require('Game/Enemy/enemy')
local tempText = require('1stPartyLib/display/tempText')
function state.load()
end

function state.update(dt)
	STATE.hud:update(dt)
	STATE.player:update(dt)

	for i = #STATE.powerups, 1, -1 do
		local p = STATE.powerups[i]
		p:update(dt)
		if collision.polygons(p.polygon, STATE.player.polygon) then
			--give the power to the player
			if p:apply(STATE.player) then
				table.remove(STATE.powerups,i)
			end			
		elseif not collision.polygons(p.polygon, STATE.camera.polygon) then
			table.remove(STATE.powerups, i)
		end
	end

	for i=#STATE.player.missiles,1,-1 do
		local missile = STATE.player.missiles[i]
		missile:update(dt)
		if not collision.polygons(missile.polygon, STATE.camera.polygon) then
			table.remove(STATE.player.missiles,i)
		else
			for j,e in ipairs(STATE.enemies) do
				if collision.polygons(missile.polygon,e.polygon) then
					local found
					if missile.piercedList then
						for a,f in ipairs(missile.piercedList) do
							if e == f then
								found = true
								break
							end
						end
					end
					--print('collide')
						--e.HELP = true
					--	missile.help = true
					--	STATE.paused = true
					if not found then
						e.health = e.health - missile.damage
						
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
						missile.pierce = missile.pierce and missile.pierce - 1
						STATE.screenshake = STATE.screenshake+0.3
						if missile.type == 'basic' then
							if missile.pierce > 0 then
								table.insert(missile.piercedList,e)
							else
								table.remove(STATE.player.missiles,i)
								break
							end
						elseif missile.type == 'split' then--crazy missile don't have piercing yet
							if missile.pierce + 1 > 0 then
								table.insert(STATE.player.missiles,laser.make{
												x= missile.x
												,y=missile.y
												,speed=missile.speed
												,angle=missile.angle + math.pi/2
												,damage=missile.damage
												,pierce=missile.pierce
												,Image=images.greenLaser
												,width = missile.width
												,type = 'split'
												,piercedList = {e}
											}
										)
								table.insert(STATE.player.missiles,laser.make{
												x= missile.x
												,y=missile.y
												,speed=missile.speed
												,angle=missile.angle - math.pi/2
												,damage=missile.damage
												,pierce=missile.pierce
												,Image=images.greenLaser
												,width = missile.width
												,type = 'split'
												,piercedList = {e}
											}
										)
							end
						else
							e.health = -1
						end
						if missile.pierce and missile.pierce > 0 then
							table.insert(missile.piercedList,e)
						elseif missile.pierce then
							table.remove(STATE.player.missiles,i)
							break
						end
					end
				else
				--	e.HELP = nil
				--	missile.help = nil
				end
			end --end of enemy loop

			if missile.type == 'mega' then
				local em
				for k = #STATE.enemyMissiles,1,-1 do
					em = STATE.enemyMissiles[k]
					if collision.polygons(missile.polygon, em.polygon) then
						table.remove(STATE.enemyMissiles, k)
					end

				end
			end
		end
	end
	for i=#STATE.enemies,1,-1 do
		local v = STATE.enemies[i]
		v:update(dt)

			v.HELP = false
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
			sounds.explosion:play()
		elseif collision.polygons(STATE.player.polygon,v.polygon) then--STATE.player.collisionBox:collideRectangle(v.collisionBox) then
			v.HELP = true
			print('enemy')
			if not STATE.player.isCloaked then
				if STATE.player.shield > 0 then 
					STATE.player.shield = STATE.player.shield - 1
					v.health = -1
				else
					if die then
						STATE.player:die()
					else
						STATE.paused = true
					end
				end
			end
		elseif v.drawBox:getLeft() > STATE.camera.x+STATE.camera.width/2 then
			v.x = STATE.camera.x-STATE.camera.width/2 - v.drawBox.width/2
			v.xspeed = math.abs(v.xspeed)
		elseif v.drawBox:getRight() < STATE.camera.x-STATE.camera.width/2 then
			v.x = STATE.camera.x+STATE.camera.width/2 + v.drawBox.width/2
			v.xspeed = -math.abs(v.xspeed)
		end
	end

	--print('paused = ' ..  tostring(STATE.paused))
	if not STATE.player.dead then
		for i=#STATE.enemyMissiles,1,-1 do
			local missile = STATE.enemyMissiles[i]
			missile:update(dt)
			missile.HELP = false
			if collision.polygons(STATE.player.polygon, missile.polygon) then--missile:isHittingRectangle(STATE.player.collisionBox:getRect()) then
				if myDebug then require("mobdebug").on() end
        missile.HELP = true
				if not STATE.player.isCloaked then
					if STATE.player.shield > 0 then 
						STATE.player.shield = STATE.player.shield - 1
						table.remove(STATE.enemyMissiles,i)
					else
						if die then
							STATE.player:die()
						else
							STATE.paused = true
						end
					end
				end
         if myDebug then require("mobdebug").off() end
			elseif not collision.polygons(missile.polygon, STATE.camera.polygon) then
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
	elseif key == 't' then
		table.insert(STATE.powerups, powerup.make{
			x = STATE.player.x,
			y = 0,
			xspeed = 0,
			yspeed = 150,
			type = 'megaLaser'
			})
	else
		STATE.player:keypressed(key)
	end
end

function state.mousepressed(x,y,button)
	if button == 2 then
		STATE.paused = true
		return
	end
	if collision.pointRectangle(x,y,STATE.hud.x,STATE.hud.y,STATE.hud.width,STATE.hud.height) then
		STATE.hud:mousepressed(x,y,button)
	else
		STATE.player:mousepressed(x,y,button)
	end
end

return state