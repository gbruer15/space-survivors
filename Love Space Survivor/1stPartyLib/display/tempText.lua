local tempText = {}
tempText.__index = tempText

function tempText.make(att)
	local self = {}
	setmetatable(self,tempText)

	self.x = att.x or 0
	self.y = att.y or 0

	self.xspeed = att.xspeed or 0
	self.yspeed = att.yspeed or 0

	self.life = att.life or 1

	self.color = att.color or {255,255,255}
	self.text = att.text or '0'
	return self
end

function tempText:update(dt)
	self.x = self.x + self.xspeed*dt
	self.y = self.y + self.yspeed*dt

	self.life = self.life - dt

	self.destroy = self.life < 0
end

function tempText:draw()
	self.color[4] = self.life > 0.5 and 255 or self.life/0.5*255
	love.graphics.setColor(self.color)
	love.graphics.print(self.text,self.x,self.y)
end

return tempText