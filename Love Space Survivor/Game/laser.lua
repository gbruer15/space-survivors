laser = {}
laser.__index = laser

function laser.make(att)
	local self = {}
	setmetatable(self,laser)

	self.x = att.x or 0
	self.y = att.y or 0

	self.speed = att.speed or 10
	self.angle = att.angle or -math.pi/2

	self.damage = att.damage or 1
	self.pierce = att.pierce or 1

	if self.pierce > 1 then
		self.piercedList = {}
	end

	if not att.Image then
		if att.image then
			self.Image = {}
			self.Image.image = att.image
			self.Image.width = att.image:getWidth()
			self.Image.height = att.image:getHeight()
		else
			self.Image = images.redLaser
		end
	else
		self.Image = att.Image
	end

	self.width = att.width or 8
	self.length = att.length or self.width * self.Image.height/self.Image.width
	
	self.imageAngle = math.pi/2

	self.drawBox = rectangle.make(att.drawWidth or self.width, att.drawHeight or self.length, self)

	self.endX, self.endY = self.x+self.length*math.cos(self.angle), self.y+self.length*math.sin(self.angle)
	return self
end

function laser:update(dt)
	self.x = self.x + self.speed*math.cos(self.angle)*dt
	self.y = self.y + self.speed*math.sin(self.angle)*dt

	self.endX, self.endY = self.x+self.length*math.cos(self.angle), self.y+self.length*math.sin(self.angle)

end

function laser:draw()
	love.graphics.push()
	love.graphics.translate(self.x,self.y)
	love.graphics.rotate(self.angle+self.imageAngle)
	love.graphics.translate(-self.x,-self.y)

	love.graphics.setColor(255,255,255)
	love.graphics.draw(self.Image.image,self.drawBox:getLeft(),self.drawBox:getTop(),0,self.drawBox.width/self.Image.width,self.drawBox.height/self.Image.height)

	love.graphics.pop()

	love.graphics.setLineWidth(1)
	--love.graphics.line(self.x, self.y, self.endX, self.endY)
end

function laser:isHittingRectangle(x,y,w,h)
	return collision.pointRectangle(self.x,self.y, x,y,w,h) or collision.pointRectangle(self.endX,self.endY, x,y,w,h)
end