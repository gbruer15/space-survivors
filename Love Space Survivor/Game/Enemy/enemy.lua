local enemy = {}
enemy.__index = enemy
require('Game/missile')
function enemy.make(att)
	local self = {}
	setmetatable(self, enemy)

	require("1stPartyLib/display/rectangle")
	self.relDrawBox = rectangle.make(50,60)

	self.relCollisionBox = rectangle.make(30,40)

	self.x = att.x or 0
	self.y = att.y or 0

	self.absCollisionBox = {}
	self.absCollisionBox.x = self.relCollisionBox.x + self.x
	self.absCollisionBox.y = self.relCollisionBox.y + self.y
	self.absCollisionBox.width = self.relCollisionBox.width
	self.absCollisionBox.height = self.relCollisionBox.height

	self.yspeed = att.yspeed or 100

	self.missiles = {}
	self.firing = true
	self.fireDelay = att.fireDelay or 2
	self.fireCountdown = self.fireDelay

	self.health = att.health or 1

	return self
end

function enemy:update(dt)
	self.y = self.y + self.yspeed*dt

	self.absCollisionBox.x = self.relCollisionBox.x + self.x
	self.absCollisionBox.y = self.relCollisionBox.y + self.y

	self.fireCountdown = self.fireCountdown - dt
	if self.fireCountdown <= 0 and self.firing then
		self:fireMissile()
		self.fireCountdown = self.fireDelay
	end
end

function enemy:draw()
	love.graphics.setColor(255,0,0)
	self.relDrawBox:draw('fill',self.x,self.y)

	love.graphics.setColor(0,255,0,100)
	self.relCollisionBox:draw('fill',self.x,self.y)	
end

function enemy:fireMissile()
	table.insert(self.missiles,missile.make(self.x,self.y+self.relDrawBox.height/2, 500,math.pi/2))
end

return enemy