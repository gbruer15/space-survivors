missile = {}
missile.__index = missile

function missile.make(att,x,y,speed,angle, length, width)
	local self = {}
	setmetatable(self,missile)

	self.x = att.x or 0
	self.y = att.y or 0

	self.speed = att.speed or 10
	self.angle = att.angle or -math.pi/2

	self.damage = att.damage or 1

	self.length = att.length or 10
	self.width = att.width or 2

	self.endX, self.endY = self.x+self.length*math.cos(self.angle), self.y+self.length*math.sin(self.angle)
	return self
end

function missile:update(dt)
	self.x = self.x + self.speed*math.cos(self.angle)*dt
	self.y = self.y + self.speed*math.sin(self.angle)*dt

	self.endX, self.endY = self.x+self.length*math.cos(self.angle), self.y+self.length*math.sin(self.angle)

end

function missile:draw()
	love.graphics.setLineWidth(self.width)

	love.graphics.line(self.x, self.y, self.endX, self.endY)
end

function missile:isHittingRectangle(x,y,w,h)
	return collision.pointRectangle(self.x,self.y, x,y,w,h) or collision.pointRectangle(self.endX,self.endY, x,y,w,h)
end