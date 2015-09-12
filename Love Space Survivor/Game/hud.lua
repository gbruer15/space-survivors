local hud = {}
hud.__index= hud
function hud.make(att)
	local self = {}
	setmetatable(self,hud)

	self.x = att.x or 0
	self.y = att.y or 0

	self.width = att.width or 100
	self.height = att.height or 100

	self.hoveredUpgrade = false
	self.upgradesX = self.x+15
	self.upgradesY = self.y+315
	self.upgradesHeight=15

	self.buttons = {}
	self.buttons.pause = button.make{
								centerx = self.x+self.width/2
								,centery = self.y+self.height-100
								,text = 'P(ause)'
							}
	self.buttons.returnToLevelSelect = button.make{
								centerx = self.x+self.width/2
								,centery = self.y+self.height-50
								,text = 'Level Select'
							}
	return self
end


function hud:update(dt)
	if self.boolBox then
		self.boolBox:update(dt)
	end
	for i,b in pairs(self.buttons) do
		b:update(dt)
	end

	--check for hovering over upgrade
	if MOUSE.x > self.x then
		local i = math.ceil((MOUSE.y-self.upgradesY)/self.upgradesHeight)
		if i >= 1 and i <= #STATE.upgrades then
			self.hoveredUpgrade = STATE.upgrades[i]
			self.selectedIndex = i
		else
			self.hoveredUpgrade = false
			self.selectedIndex = false
		end
	else
		self.hoveredUpgrade = false
		self.selectedIndex = false
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

	if STATE.level.drawToHud then
		STATE.level.drawToHud(self.x+15,225,self.width-30,20)
	end

	if self.hoveredUpgrade then
		love.graphics.printf(self.hoveredUpgrade.description,self.x+15,315+#STATE.upgrades*15,self.width,'center')
		love.graphics.setColor(50,50,50)
		love.graphics.rectangle('fill',self.upgradesX, self.upgradesY+(self.selectedIndex-1)*15,self.width,self.upgradesHeight)
	end

	love.graphics.setColor(255,255,255)
	love.graphics.print('Upgrades',self.x+15,280)
	local x = self.upgradesX
	for i,v in ipairs(STATE.upgrades) do
		y = self.upgradesY+(i-1)*15
		if v:getMaxedOut() then
			love.graphics.setColor(100,100,100)
			love.graphics.print(v.name .. ': Maxed Out',x,y)
		elseif STATE.player.levelCash < v.cost then
			love.graphics.setColor(200,0,0)
			love.graphics.print(v.name .. ': $' .. v.cost,x,y)
		else
			love.graphics.setColor(40,200,40)
			love.graphics.print(v.name .. ': $' .. v.cost,x,y)
		end		
	end


	for i,b in pairs(self.buttons) do
		b:draw()
	end

	love.graphics.setColor(255,255,255)
	love.graphics.print('FPS: ' .. love.timer.getFPS(),self.x + 4, self.y + self.height - 35)

	if self.boolBox then
		self.boolBox:draw()
	end
	
end

function hud:mousepressed(x,y,button)
	if self.boolBox then
		self.boolBox:mousepressed(x,y,button)
		if self.boolBox.value then
			STATE = require('Game/States/levelselect')
			STATE.load()
		elseif self.boolBox.value == false then
			self.boolBox = nil
		end
	end
	if self.buttons.pause.hover then
		STATE.paused = true
	elseif self.buttons.returnToLevelSelect.hover then
		STATE.paused = true
		self.boolBox = boolBox.make{
								centerx=window.width/2 
								,centery=window.height/2
								,titleText='Quit and return to level select?'
								,boxColor={200,0,0,155}
								,trueText = 'Yes'
								,falseText = 'No'
							}
	elseif self.hoveredUpgrade then
		--attempt to buy upgrade
		if not self.hoveredUpgrade:getMaxedOut() and self.hoveredUpgrade.cost < STATE.player.levelCash then
			STATE.player.levelCash = STATE.player.levelCash - self.hoveredUpgrade.cost
			self.hoveredUpgrade:increment(STATE.player)
		end
	end
end

return hud