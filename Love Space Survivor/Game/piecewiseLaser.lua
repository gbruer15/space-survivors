piecewiseLaser = {}
piecewiseLaser.__index = piecewiseLaser

require('1stPartyLib/display/animation')

function piecewiseLaser.make(att)
	local self = {}
	setmetatable(self,piecewiseLaser)

	self.x = att.x or 0
	self.y = att.y or 0 --this starts out as the bottom of the image

	self.speed = att.speed or 100
	self.angle = att.angle or -math.pi/2

	self.damage = att.damage or 1

	self.type = att.type or 'basic'

	if self.type ~= 'mega' then
		self.pierce = att.pierce or 1
		if self.pierce > 1 then
			self.piercedList = att.piercedList or {}
		end
	end

	self.Image = assert(att.Image)
	self.TopImage = assert(att.TopImage)
	self.MiddleImage = assert(att.MiddleImage)
	self.BottomImage = assert(att.BottomImage)

	self.width = att.width or 8
	self.length = att.length or self.width * self.Image.height/self.Image.width

	self.topHeight = self.length * self.TopImage.height/self.Image.height
	self.bottomHeight = self.length * self.BottomImage.height/self.Image.height
	self.middleHeight = self.length - self.topHeight - self.bottomHeight --calculate middle from other two, because the image isn't the whole middle
	
	self.imageAngle = math.pi/2

	self.drawBox = rectangle.make(att.drawWidth or self.width, att.drawHeight or self.length, self, nil, nil, att.drawHeight or self.length)

	self.endX, self.endY = self.x+self.length*math.cos(self.angle), self.y+self.length*math.sin(self.angle)

	self.points = {}
	self.points[1] = {}
	self.points[2] = {}
	self.points[3] = {}
	self.points[4] = {}
	self.points[5] = {}
	self.points[6] = {}

	self.subPoints = {}
	self.subPoints[1] = {}
	self.subPoints[2] = {}
	self.subPoints[3] = {}
	self.subPoints[4] = {}
	self.subPoints[5] = {}
	self.subPoints[6] = {}
	self.subPoints[7] = {}

	self.lengthAnimation = animation.make(0,self.length,self.length/self.speed*5)
	self.done = false

	self.bottomQuad = love.graphics.newQuad(0,0, 10,10, self.BottomImage.width, self.BottomImage.height)
	self.middleQuad = love.graphics.newQuad(0,0, 10,10, self.MiddleImage.width, self.MiddleImage.height)
	self.topQuad= love.graphics.newQuad(0,0, 10,10, self.TopImage.width, self.TopImage.height)

	return self
end

function piecewiseLaser:update(dt)
	if not self.done then
		self.lengthAnimation:update(dt)
		self.drawBox:changeHeight(self.lengthAnimation.value)
		self.done = (self.lengthAnimation.value == self.length)

		self.x = STATE.player.x
		self.y =  STATE.player.y - STATE.player.drawBox.height/2

	else
		self.x = self.x + self.speed*math.cos(self.angle)*dt
		self.y = self.y + self.speed*math.sin(self.angle)*dt
	end

	self.startX,self.startY = self.x, self.y--self.length/2*math.sin(self.angle)
	self.endX = self.x + self.length*math.cos(self.angle)
	self.endY = self.y + self.length*math.sin(self.angle)

	self.bx = self.x+self.width/2 * math.sin(self.angle) + (self.bottomHeight+self.middleHeight/2)*math.cos(self.angle)
	self.by = self.y-self.width/2 * math.cos(self.angle) + (self.bottomHeight+self.middleHeight/2)*math.sin(self.angle)

	self.cx = self.x-self.width/2 * math.sin(self.angle) + (self.bottomHeight+self.middleHeight/2)*math.cos(self.angle)
	self.cy = self.y+self.width/2 * math.cos(self.angle) + (self.bottomHeight+self.middleHeight/2)*math.sin(self.angle)

	if self.done then
		self.points[1].x = self.startX 
		self.points[1].y = self.startY

		self.points[4].x = self.endX 
		self.points[4].y = self.endY

		self.points[3].x = self.bx + self.middleHeight/2*math.cos(self.angle)
		self.points[3].y = self.by + self.middleHeight/2*math.sin(self.angle)

		self.points[2].x = self.bx - self.middleHeight/2*math.cos(self.angle)
		self.points[2].y = self.by - self.middleHeight/2*math.sin(self.angle)

		self.points[6].x = self.cx - self.middleHeight/2*math.cos(self.angle)
		self.points[6].y = self.cy - self.middleHeight/2*math.sin(self.angle)

		self.points[5].x = self.cx + self.middleHeight/2*math.cos(self.angle)
		self.points[5].y = self.cy + self.middleHeight/2*math.sin(self.angle)
	else
		self.subPoints[1].x = self.startX
		self.subPoints[1].y = self.startY
		if self.drawBox.height <= self.bottomHeight then
			--it's just the bottom triangle
			local prop = self.drawBox.height/self.bottomHeight

			self.subPoints[2].x = self.startX + ((self.bx - self.middleHeight/2*math.cos(self.angle)) - self.startX)*prop
			self.subPoints[2].y = self.startY + ((self.by - self.middleHeight/2*math.sin(self.angle)) - self.startY)*prop

			self.subPoints[3].x = self.startX + ((self.cx - self.middleHeight/2*math.cos(self.angle)) - self.startX)*prop
			self.subPoints[3].y = self.startY + ((self.cy - self.middleHeight/2*math.sin(self.angle)) - self.startY)*prop
		elseif self.drawBox.height <= self.bottomHeight + self.middleHeight then
			--it's the bottom triangle plus the middle rectangle
			self.subPoints[2].x = self.bx - self.middleHeight/2*math.cos(self.angle)
			self.subPoints[2].y = self.by - self.middleHeight/2*math.sin(self.angle)

			self.subPoints[5].x = self.cx - self.middleHeight/2*math.cos(self.angle)
			self.subPoints[5].y = self.cy - self.middleHeight/2*math.sin(self.angle)

			--middle rectangle
			local middleHeight = self.drawBox.height - self.bottomHeight
			self.subPoints[3].x = self.subPoints[2].x + middleHeight*math.cos(self.angle)
			self.subPoints[3].y = self.subPoints[2].y + middleHeight*math.sin(self.angle)

			self.subPoints[4].x = self.subPoints[5].x + middleHeight*math.cos(self.angle)
			self.subPoints[4].y = self.subPoints[5].y + middleHeight*math.sin(self.angle)
		elseif self.drawBox.height <= self.bottomHeight + self.middleHeight + self.topHeight then
			--it's the bottom triangle plus the middle rectangle plus the top trapezoid
			self.subPoints[2].x = self.bx - self.middleHeight/2*math.cos(self.angle)
			self.subPoints[2].y = self.by - self.middleHeight/2*math.sin(self.angle)

			self.subPoints[7].x = self.cx - self.middleHeight/2*math.cos(self.angle)
			self.subPoints[7].y = self.cy - self.middleHeight/2*math.sin(self.angle)

			--middle rectangle
			self.subPoints[3].x = self.subPoints[2].x + self.middleHeight*math.cos(self.angle)
			self.subPoints[3].y = self.subPoints[2].y + self.middleHeight*math.sin(self.angle)

			self.subPoints[6].x = self.subPoints[7].x + self.middleHeight*math.cos(self.angle)
			self.subPoints[6].y = self.subPoints[7].y + self.middleHeight*math.sin(self.angle)

			--top trapezoid
			local prop = (self.drawBox.height - self.middleHeight - self.bottomHeight)/self.topHeight
			self.subPoints[4].x = self.subPoints[3].x + (self.endX - self.subPoints[3].x)*prop
			self.subPoints[4].y = self.subPoints[3].y + (self.endY - self.subPoints[3].y)*prop

			self.subPoints[5].x = self.subPoints[6].x + (self.endX - self.subPoints[6].x)*prop
			self.subPoints[5].y = self.subPoints[6].y + (self.endY - self.subPoints[6].y)*prop
		end
	end
end

function piecewiseLaser:draw()
	love.graphics.push()
	love.graphics.translate(self.x,self.y)
	love.graphics.rotate(self.angle+self.imageAngle)
	love.graphics.translate(-self.x,-self.y)

	love.graphics.setColor(255,255,255)
	if self.HELP then love.graphics.setColor(255,0,255) end

	if self.done then
		love.graphics.draw(self.BottomImage.image, self.drawBox:getLeft(), self.drawBox:getBottom()-self.bottomHeight,
									0, self.drawBox.width/self.BottomImage.width, self.bottomHeight/self.BottomImage.height)
		love.graphics.draw(self.MiddleImage.image, self.drawBox:getLeft(), self.drawBox:getBottom() - self.bottomHeight - self.middleHeight,
									0, self.drawBox.width/self.MiddleImage.width, self.middleHeight/self.MiddleImage.height)
		love.graphics.draw(self.TopImage.image, self.drawBox:getLeft(), self.drawBox:getTop(),
									0, self.drawBox.width/self.TopImage.width, self.topHeight/self.TopImage.height)
	else
		if self.drawBox.height <= self.bottomHeight then
			local quadHeight = self.BottomImage.height * self.drawBox.height/self.bottomHeight
			self.bottomQuad:setViewport(0, self.BottomImage.height - quadHeight, self.BottomImage.width, quadHeight)
			love.graphics.draw(self.BottomImage.image, self.bottomQuad, self.drawBox:getLeft(),self.drawBox:getTop(), 0,self.drawBox.width/self.BottomImage.width,self.drawBox.height/quadHeight)
		elseif self.drawBox.height <= self.bottomHeight + self.middleHeight then
			love.graphics.draw(self.BottomImage.image, self.drawBox:getLeft(), self.drawBox:getBottom()-self.bottomHeight,
									0, self.drawBox.width/self.BottomImage.width, self.bottomHeight/self.BottomImage.height)
			love.graphics.draw(self.MiddleImage.image, self.drawBox:getLeft(), self.drawBox:getTop(),
									0, self.drawBox.width/self.MiddleImage.width, (self.drawBox.height-self.bottomHeight)/self.MiddleImage.height)
		elseif self.drawBox.height <= self.bottomHeight + self.middleHeight + self.topHeight then
			love.graphics.draw(self.BottomImage.image, self.drawBox:getLeft(), self.drawBox:getBottom()-self.bottomHeight,
									0, self.drawBox.width/self.BottomImage.width, self.bottomHeight/self.BottomImage.height)
			love.graphics.draw(self.MiddleImage.image, self.drawBox:getLeft(), self.drawBox:getBottom() - self.bottomHeight - self.middleHeight,
									0, self.drawBox.width/self.MiddleImage.width, self.middleHeight/self.MiddleImage.height)

			local drawHeight = self.drawBox.height - self.bottomHeight - self.middleHeight
			local quadHeight = self.TopImage.height * drawHeight/self.topHeight
			self.topQuad:setViewport(0, self.TopImage.height - quadHeight, self.TopImage.width, quadHeight)

			love.graphics.draw(self.TopImage.image, self.topQuad, self.drawBox:getLeft(), self.drawBox:getTop(), 
								0, self.drawBox.width/self.TopImage.width, drawHeight/quadHeight)
		end
	end
	love.graphics.pop()

	local vertices = self:getPolygon()

	love.graphics.setColor(0,0,255)
end

function piecewiseLaser:isHittingRectangle(x,y,w,h)
	return collision.polygons(self:getPolygon(),{x,y, x+w,y, x+w,y+h, x,y+h})
end

function piecewiseLaser:getPolygon()
	local p = {}
	if self.done then
		for i,v in ipairs(self.points) do
			table.insert(p,v.x)
			table.insert(p,v.y)
		end
	else
		local endi 
		if self.drawBox.height <= self.bottomHeight then
			endi = 3
		elseif self.drawBox.height <= self.bottomHeight + self.middleHeight then
			endi = 5
		elseif self.drawBox.height <= self.bottomHeight + self.middleHeight + self.topHeight then
			endi = 7
		end

		local v
		for i = 1, endi do
			v = self.subPoints[i]
			table.insert(p,v.x)
			table.insert(p,v.y)
		end
	end

	return p
end