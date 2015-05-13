missile = {}
missile.__index = missile

function missile.make(x,y,speed,angle, length, width)
	local self = {}
	setmetatable(self,missile)

	self.x = x
	self.y = y

	self.speed = speed
	self.angle = angle

	self.length = length or 10
	self.width = width or 2

	return self
end

function missile:update(dt)
	self.x = self.x + self.speed*math.cos(angle)*dt
	self.y = self.y + self.speed*math.sin(angle)*dt

	self.endX, self.endY = self.x+self.length*math.cos(angle), self.y+self.length*math.sin(angle)
end

function missile:draw()
	love.graphics.setLineWidth(self.width)

	love.graphics.line(self.x, self.y, self.endX, self.endY)
end