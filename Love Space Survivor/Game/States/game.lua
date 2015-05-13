local state = {}

local enemy = require('Game/Enemy/enemy')
function state.load()
	state.player = require("Game/Player/player").make()
	state.camera = require("1stPartyLib/display/camera").make()

	state.missiles = {}
	state.enemies = {}
end

function state.update(dt)
	state.player:update(dt)
	for i=#state.player.missiles, 1, -1 do
		table.insert(state.missiles, table.remove(state.player.missiles))
	end


	for i=#state.missiles,1,-1 do
		local missile = state.missiles[i]
		missile:update(dt)
		if state.camera.isOffscreen(missile.x, missile.y) and state.camera.isOffscreen(missile.endX, missile.endY) then
			table.remove(state.missiles,i)
		else
			for j,e in ipairs(state.enemies) do
				if missile:collideRectangle(e.absCollisionBox) then
					e.health = e.health - missile.damage
					table.remove(state.missiles,i)
					break
				end
			end
		end
	end
	for i=#state.enemies,1,-1 do
		local v = state.enemies[i]
		v:update(dt)
		for j=#v.missiles, 1, -1 do
			table.insert(state.missiles, table.remove(v.missiles))
		end
		if v.y - v.relDrawBox.height/2 >= state.camera.y + state.camera.height/2 then
			table.remove(state.enemies,i)
		elseif v.health <= 0 then
			print('dead')
			table.remove(state.enemies,i)
		end
	end
end

function state.draw()
	state.player:draw()

	for i,v in ipairs(state.missiles) do
		v:draw()
	end

	for i,v in ipairs(state.enemies) do
		v:draw()
	end

	love.graphics.setColor(255,255,255)
	love.graphics.circle('fill',window.width/2,window.height/2,2)
end

function state.keypressed(key)

end

function state.mousepressed(x,y,button)
	state.player:fireMissile()
	table.insert(state.enemies, enemy.make{x=math.random(100,500)})
end

return state