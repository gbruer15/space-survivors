projectile = {}
projectile.__index = projectile

function projectile.make(att)
	local self = {}
	setmetatable(self,projectile)

	self.x = att.x or 0
	self.y = att.y or 0

	self.Image = att.Image or {}

	if not att.Image then
		if att.image then
			self.Image.image = att.image
			self.Image.width = att.image:getWidth()
			self.Image.height = att.image:getHeight()
		else
			self.Image = images.tinySpiral
		end
	end

	self.drawBox = rectangle.make(att.width or 15, att.height or 15, self)
	self.drawAngle = math.random()*math.pi
	self.angleSpeed = att.angleSpeed or math.random()*40 + 0.1

	self.speed = att.speed or 10
	self.angle = att.angle or -math.pi/2

	self.damage = att.damage or 1
	self.pierce = att.pierce or 1

	return self
end

function projectile:update(dt)
	self.x = self.x + self.speed*math.cos(self.angle)*dt
	self.y = self.y + self.speed*math.sin(self.angle)*dt

	self.angle = self.angle + (math.random()-0.5)*self.speed/1500*math.max(self.angleSpeed/30,1)

	self.drawAngle = self.drawAngle + self.angleSpeed*dt
end

function projectile:draw()
	love.graphics.push()
	love.graphics.translate(self.x,self.y)
	love.graphics.rotate(self.drawAngle)
	love.graphics.translate(-self.x,-self.y)

	love.graphics.setColor(255,255,255)
	love.graphics.draw(self.Image.image,self.drawBox:getLeft(),self.drawBox:getTop(),0,self.drawBox.width/self.Image.width,self.drawBox.height/self.Image.height)
	--love.graphics.rectangle('line',self.drawBox:getRect())

	love.graphics.pop()
end

function projectile:isHittingRectangle(x,y,w,h)
	return collision.rectangleCircle(x,y,w,h, self.x,self.y,self.drawBox.width/2)--collision.rectangles(x,y,w,h,self.drawBox:getRect())
	--collision.pointRectangle(self.x,self.y, x,y,w,h) or collision.pointRectangle(self.endX,self.endY, x,y,w,h)
end