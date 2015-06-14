local enemy = {}
enemy.__index = enemy
require('Game/missile')
function enemy.make(att)
	local self = {}
	setmetatable(self, enemy)

	require("1stPartyLib/display/rectangle")

	self.x = att.x or 0
	self.y = att.y or 0

	self.Image = images.enemySpaceship

	local width = att.width or 50
	local scale = width/self.Image.width
	self.drawBox = rectangle.make(width,scale*self.Image.height, self)
	self.collisionBox = rectangle.make(scale*88,scale*205,self)

	self.drawBox.height = self.drawBox.width/self.Image.width*self.Image.height
	self.drawBox.dy = self.drawBox.height/2

	self.yspeed = att.yspeed or 100

	self.firing = att.firing
	self.fireDelay = att.fireDelay or 1
	self.fireCountdown = self.fireDelay

	self.missileSpeed = att.missileSpeed or  400

	self.health = att.health or 1

	self.loot = att.loot or math.ceil(self.drawBox.width * (math.random() + 0.5))
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

function enemy:draw(drawColBox, colBoxMode)
	love.graphics.setColor(255,255,255)
	love.graphics.draw(self.Image.image,self.drawBox:getLeft(),self.drawBox:getTop(),0,self.drawBox.width/self.Image.width, self.drawBox.height/self.Image.height)

	if drawColBox then
		love.graphics.setColor(color or {0,255,0,100})
		self.collisionBox:draw(colBoxMode or 'line')
	end
end

function enemy:fireMissile()
	table.insert(STATE.enemyMissiles,missile.make{
													x=self.x
													,y=self.drawBox:getBottom()
													,speed=self.missileSpeed
													,angle=math.pi/2}
												)
end

return enemy