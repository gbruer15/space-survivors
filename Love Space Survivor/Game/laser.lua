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

	self.type = att.type or 'basic'

	if self.type ~= 'mega' then
		self.pierce = att.pierce or 1
		if self.pierce > 1 then
			self.piercedList = att.piercedList or {}
		end
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
	
	self.points = {}
	self.points[1] = {}
	self.points[2] = {}
	self.points[3] = {}
	self.points[4] = {}
	self.points[5] = {}
	self.points[6] = {}

	self:setPoints()

	self.polygon = {}
	self:updatePolygon()


	return self
end

function laser:update(dt)
	self.x = self.x + self.speed*math.cos(self.angle)*dt
	self.y = self.y + self.speed*math.sin(self.angle)*dt

	self:setPoints()
	self:updatePolygon()
end

function laser:setPoints()
	self.startX,self.startY = self.x-self.length/2*math.cos(self.angle), self.y-self.length/2*math.sin(self.angle)

	self.endX, self.endY = self.x+self.length/2*math.cos(self.angle), self.y+self.length/2*math.sin(self.angle)


	self.points[1].x = self.startX 
	self.points[1].y = self.startY

	self.points[4].x = self.endX 
	self.points[4].y = self.endY

	self.bx = self.x+self.width/2 * math.sin(self.angle)
	self.by = self.y-self.width/2 * math.cos(self.angle)

	self.points[3].x = self.bx + self.length*0.35*math.cos(self.angle)
	self.points[3].y = self.by + self.length*0.35*math.sin(self.angle)

	self.points[2].x = self.bx - self.length*0.35*math.cos(self.angle)
	self.points[2].y = self.by - self.length*0.35*math.sin(self.angle)

	
	self.cx = self.x-self.width/2 * math.sin(self.angle)
	self.cy = self.y+self.width/2 * math.cos(self.angle)

	self.points[6].x = self.cx - self.length*0.35*math.cos(self.angle)
	self.points[6].y = self.cy - self.length*0.35*math.sin(self.angle)

	self.points[5].x = self.cx + self.length*0.35*math.cos(self.angle)
	self.points[5].y = self.cy + self.length*0.35*math.sin(self.angle)
end

function laser:draw()
	love.graphics.push()
	love.graphics.translate(self.x,self.y)
	love.graphics.rotate(self.angle+self.imageAngle)
	love.graphics.translate(-self.x,-self.y)

	love.graphics.setColor(255,255,255)
	if self.HELP then love.graphics.setColor(255,0,255) end
	love.graphics.draw(self.Image.image,self.drawBox:getLeft(),self.drawBox:getTop(),0,self.drawBox.width/self.Image.width,self.drawBox.height/self.Image.height)

	love.graphics.pop()


	love.graphics.setColor(0,0,255)
	
	--love.graphics.polygon('line',self.polygon)

	--Collision lines
	--[[]
	love.graphics.setColor(0,255,255)
	love.graphics.setLineWidth(1)
	love.graphics.line(self.points[1].x, self.points[1].y, self.points[4].x, self.points[4].y)

	love.graphics.line(self.points[2].x,self.points[2].y,self.points[3].x,self.points[3].y)
	love.graphics.line(self.points[5].x,self.points[5].y,self.points[6].x,self.points[6].y)
	--]]
end

function laser:isHittingRectangle(x,y,w,h)
	return collision.polygons(self:getPolygon(),{x,y, x+w,y, x+w,y+h, x,y+h})
end

function laser:updatePolygon()
	for i,v in ipairs(self.points) do
		self.polygon[2*i - 1] = v.x
		self.polygon[2*i] = v.y
	end
end