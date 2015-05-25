local hud = {}
hud.__index= hud
function hud.make(att)
	local self = {}
	setmetatable(self,hud)

	self.x = att.x or 0
	self.y = att.y or 0

	self.width = att.width or 100
	self.height = att.height or 100

	self.hoveredUpgrade = STATE.upgrades[1]

	self.buttons = {}
	self.buttons.pause = button.make{
								centerx = self.x+self.width/2
								,centery = self.y+self.height-100
								,text = 'P(ause)'
							}


	return self
end


function hud:update(dt)
	for i,b in pairs(self.buttons) do
		b:update(dt)
	end
end


function hud:draw()

	love.graphics.setColor(0,0,255)
	love.graphics.rectangle('fill',self.x,self.y,self.width,self.height)

	love.graphics.setColor(255,255,255)
	outlines.basicOutline:draw(self.x,self.y,self.width,self.height)


	love.graphics.printf('Level ' .. STATE.level.number, self.x,self.y,self.width,'center')

	love.graphics.print('Score: ' .. STATE.player.levelScore,self.x+15,45)

	love.graphics.print('Cash: $' .. STATE.player.levelCash,self.x+15,135)
	
	love.graphics.print('Lives: ' .. STATE.player.lives,self.x+15,180)

	love.graphics.print('Kills Left: ' .. STATE.level.killsToWin - STATE.player.levelKills,self.x+15,225)

	love.graphics.print('Upgrades',self.x+15,280)
	for i,v in ipairs(STATE.upgrades) do
		love.graphics.print(v.name .. ': $' .. v.cost,self.x+15, 300+i*15)
	end

	love.graphics.printf(self.hoveredUpgrade.description,self.x+15,315+#STATE.upgrades*15,self.width,'center')

	for i,b in pairs(self.buttons) do
		b:draw()
	end
	
end

function hud:mousepressed(x,y,button)
	if self.buttons.pause.hover then
		STATE.paused = true
	end
end

return hud