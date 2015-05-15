local hud = {}
hud.__index= hud
local outline = require('1stPartyLib/display/outline')
function hud.make(att)
	local self = {}
	setmetatable(self,hud)

	self.x = att.x or 0
	self.y = att.y or 0

	self.width = att.width or 100
	self.height = att.height or 100

	self.outline = outline.make{
								corner = images.basicOutlineCorner.image
								,straight = images.basicOutlineStraight.image
								,lineWidth = 5
							}
	self.hoveredUpgrade = STATE.upgrades[1]
	return self
end


function hud:update(dt)

end


function hud:draw()

	love.graphics.setColor(0,0,255)
	love.graphics.rectangle('fill',self.x,self.y,self.width,self.height)

	love.graphics.setColor(255,255,255)
	self.outline:draw(self.x,self.y,self.width,self.height)


	love.graphics.printf('Level ' .. STATE.level.number, self.x,self.y,self.width,'center')

	love.graphics.print('Score: ' .. STATE.player.score,self.x+15,45)

	love.graphics.print('Cash: $' .. STATE.player.cash,self.x+15,135)
	
	love.graphics.print('Lives: ' .. STATE.player.lives,self.x+15,180)

	love.graphics.print('Kills Left: ' .. STATE.level.killsToWin - STATE.player.kills,self.x+15,225)

	love.graphics.print('Upgrades',self.x+15,280)
	for i,v in ipairs(STATE.upgrades) do
		love.graphics.print(v.name .. ': $' .. v.cost,self.x+15, 300+i*15)
	end

	love.graphics.printf(self.hoveredUpgrade.description,self.x+15,315+#STATE.upgrades*15,self.width,'center')
	
end

return hud