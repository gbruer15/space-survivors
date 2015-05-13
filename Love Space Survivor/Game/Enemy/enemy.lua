local enemy = {}
enemy.__index = enemy
require('Game/missile')
function enemy.make(att)
	local self = {}
	setmetatable(self, enemy)

	require("1stPartyLib/display/rectangle")

	self.x = att.x or 0
	self.y = att.y or 0
	self.drawBox = rectangle.make(50,60, self)
	self.collisionBox = rectangle.make(30,40,self)

	self.yspeed = att.yspeed or 100

	self.missiles = {}
	self.firing = false
	self.fireDelay = att.fireDelay or 2
	self.fireCountdown = self.fireDelay

	self.health = att.health or 1

	return self
end

function enemy:update(dt)
	self.y = self.y + self.yspeed*dt

	self.fireCountdown = self.fireCountdown - dt
	if self.fireCountdown <= 0 and self.firing then
		self:fireMissile()
		self.fireCountdown = self.fireDelay
	end
end

function enemy:draw()
	love.graphics.setColor(255,0,0)
	self.drawBox:draw('fill')

	love.graphics.setColor(0,255,0,100)
	self.collisionBox:draw('fill')

	love.graphics.setColor(255,255,255,100)
	love.graphics.rectangle('fill',self.collisionBox:getLeft(),self.collisionBox:getTop(),self.collisionBox.width,self.collisionBox.height)
	--love.graphics.printf(self.health, self.x-self.relDrawBox.width/2, self.y, self.relDrawBox.width,'center')
end

function enemy:fireMissile()
	table.insert(self.missiles,missile.make(self.x,self.y+self.relDrawBox.height/2, 500,math.pi/2))
end

return enemy