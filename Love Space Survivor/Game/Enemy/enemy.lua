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
	self.collisionBox = rectangle.make(30,60,self)

	self.Image = images.enemySpaceship
	self.drawBox.height = self.drawBox.width/self.Image.width*self.Image.height
	self.drawBox.dy = self.drawBox.height/2

	self.yspeed = att.yspeed or 100

	self.missiles = {}
	self.firing = true
	self.fireDelay = att.fireDelay or 1
	self.fireCountdown = self.fireDelay

	self.health = att.health or 1

	self.loot = math.ceil(self.drawBox.width * (math.random() + 0.5))
	self.points = math.ceil(self.loot * 1.4)
	

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
	love.graphics.setColor(255,255,255)
	--self.drawBox:draw('fill')
	love.graphics.draw(self.Image.image,self.drawBox:getLeft(),self.drawBox:getTop(),0,self.drawBox.width/self.Image.width, self.drawBox.height/self.Image.height)

	love.graphics.setColor(0,255,0,100)
	self.collisionBox:draw('line')
	--love.graphics.printf(self.health, self.x-self.relDrawBox.width/2, self.y, self.relDrawBox.width,'center')
end

function enemy:fireMissile()
	table.insert(self.missiles,missile.make(self.x,self.drawBox:getBottom(), 500,math.pi/2))
end

return enemy