local playerfunctions = {}
require('Game/missile')
require('1stPartyLib/display/animation')
require('Game/projectile')
require('Game/laser')
function playerfunctions.make(att)
	local self = {}
	setmetatable(self, {__index = playerfunctions})

	self.x = STATE.camera.x
	self.y = STATE.camera.y
--hi
	self.maxXSpeed = 300
	self.maxYSpeed = 300
	self.drawBox = rectangle.make(40,125, self) --15

	self.collisionBox = rectangle.make(20,10,self)--10

	self.Image = images.spaceship--images.moveLeftAnimation

	self.Image.spriteWidth = self.Image.width
	self.Image.spriteHeight = self.Image.height

	self.quad = love.graphics.newQuad(0,0,self.Image.spriteWidth,self.Image.spriteHeight, self.Image.width,self.Image.height)
	
	self.drawBox.height = self.drawBox.width/self.Image.spriteWidth*self.Image.spriteHeight
	self.drawBox.dy = self.drawBox.height/2

	
	local xscale = self.drawBox.width/self.Image.width
	local yscale = self.drawBox.height/self.Image.height

	self.imagePoints = {}
	for i=1,#images.spaceshipPoints-1,2 do
		self.imagePoints[i] = images.spaceshipPoints[i]*xscale
		self.imagePoints[i+1] = images.spaceshipPoints[i+1]*yscale
	end


	self.missiles = {}

	self.moveAnimation = false --0
	self.moveAnimationTime = 0.3
	self.numberOfFrames = self.Image.width/self.Image.spriteWidth

	--these could be initialized from a save file
	self.levelCash = 0
	self.levelScore = 0
	self.levelKills = 0

	self.totalKills = 0
	self.totalScore = 0
	self.totalCash = 0

	self.fullauto = true
	self.fireDelay = 0.5

	self.currentLevel = 1
	self.lives = 2

	self.missileType = 1
	self.missileSpeed = 500--320
	self.missileDamage = 1
	self.missilePierce = 1
	self.missileWidth = 3

	self.fireSwirls = true
	---------------------------------

	self.fireCountdown = self.fireDelay
	return self
end

function playerfunctions:update(dt)
	self:move(dt)
	if self.x < STATE.camera.x - STATE.camera.width/2 then
		self.x = STATE.camera.x - STATE.camera.width/2
	elseif self.x > STATE.camera.x + STATE.camera.width/2 then
		self.x = STATE.camera.x + STATE.camera.width/2
	end

	self.fireCountdown = self.fireCountdown - dt
	if self.fireCountdown <= 0  then
		if self.fullauto then
			self:fireMissile()
			self.fireCountdown = self.fireDelay
		else
			self.fireCountdown = 0
		end
	end

	if self.moveAnimation then
		if love.keyboard.isDown('a') or love.keyboard.isDown('left') then
			self.moveAnimation = math.constrain(self.moveAnimation - dt*self.numberOfFrames/self.moveAnimationTime,-self.numberOfFrames,self.numberOfFrames)
		elseif love.keyboard.isDown('d') or love.keyboard.isDown('right') then
			self.moveAnimation = math.constrain(self.moveAnimation + dt*self.numberOfFrames/self.moveAnimationTime,-self.numberOfFrames,self.numberOfFrames)
		elseif self.moveAnimation > 0 then
			self.moveAnimation = math.max(self.moveAnimation-dt*self.numberOfFrames/self.moveAnimationTime,0)
		else
			self.moveAnimation = math.min(self.moveAnimation+dt*self.numberOfFrames/self.moveAnimationTime,0)
		end
		self.quad:setViewport(math.floor(math.abs(self.moveAnimation))*self.Image.spriteWidth,0,self.Image.spriteWidth,self.Image.spriteHeight)
	end
	
end

function playerfunctions:draw(drawColBox,colBoxMode,color)
	love.graphics.setColor(255,255,255)
	--self.drawBox:draw('line')

	if self.moveAnimation then
		if self.moveAnimation > 0 then
			love.graphics.draw(self.Image.image,self.quad,self.drawBox:getLeft()+self.drawBox.width,self.drawBox:getTop(),0,-self.drawBox.width/self.Image.spriteWidth, self.drawBox.height/self.Image.spriteHeight)
		else
			love.graphics.draw(self.Image.image,self.quad,self.drawBox:getLeft(),self.drawBox:getTop(),0,self.drawBox.width/self.Image.spriteWidth, self.drawBox.height/self.Image.spriteHeight)
		end
	else
		love.graphics.draw(self.Image.image,self.drawBox:getLeft(),self.drawBox:getTop(),0,self.drawBox.width/self.Image.width, self.drawBox.height/self.Image.height)
	end

	love.graphics.push()
	love.graphics.translate(self.x,self.y)

	love.graphics.setColor(0,0,255)
	--love.graphics.polygon('line',self.imagePoints)

	love.graphics.pop()

	if drawColBox then
		love.graphics.setColor(color or {0,255,0,100})
		--self.collisionBox:draw(colBoxMode or 'line')
	end
end

function playerfunctions:fireMissile()
	self.fireMissileFunctions[self.missileType](self)
end

playerfunctions.fireMissileFunctions = {}

playerfunctions.fireMissileFunctions[1] = function(self)
	self:makeMissile()
end

playerfunctions.fireMissileFunctions[2] = function(self)
	self:makeMissile(self.x-10)
	self:makeMissile(self.x+10)
end

playerfunctions.fireMissileFunctions[3] = function(self)
	self:makeMissile()
	self:makeMissile(nil,-math.pi/4)
	self:makeMissile(nil,-math.pi*3/4)
end

playerfunctions.fireMissileFunctions[4] = function(self)
	self:makeMissile(self.x-10)
	self:makeMissile(self.x+10)
	self:makeMissile(nil,-math.pi/4)
	self:makeMissile(nil,-math.pi*3/4)
end

function playerfunctions:makeMissile(x,angle)
	if self.fireSwirls then
		table.insert(self.missiles,laser.make{
											x= x or self.x
											,y=self.y-self.drawBox.height/2
											,speed=self.missileSpeed
											,angle=angle or -math.pi/2
											,damage=self.missileDamage
											,pierce=self.missilePierce
											,Image=images.greenLaser
											,width = self.missileWidth
										}
									)
		--[[table.insert(self.missiles,projectile.make{
											x= x or self.x
											,y=self.y-self.drawBox.height/2
											,speed=self.missileSpeed
											,angle=angle or -math.pi/2
											,damage=self.missileDamage
											,pierce=self.missilePierce
										}
									)]]
	else
		table.insert(self.missiles,missile.make{
											x= x or self.x
											,y=self.y-self.drawBox.height/2
											,speed=self.missileSpeed
											,angle=angle or -math.pi/2
											,damage=self.missileDamage
											,pierce=self.missilePierce
										}
									)
	end
end
function playerfunctions:keypressed(key)
end

function playerfunctions:mousepressed(x,y,button)
	if not self.fullauto and self.fireCountdown <= 0 then
		self:fireMissile()
		self.fireCountdown = self.fireDelay
	end
end

function playerfunctions:move(dt)
	if self.mouseControl then
		self.x,self.y = MOUSE.x,MOUSE.y
	else
		self.xspeed,self.yspeed = 0,0
		if love.keyboard.isDown('a') or love.keyboard.isDown('left') then
			self.xspeed = -self.maxXSpeed
		elseif love.keyboard.isDown('d') or love.keyboard.isDown('right') then
			self.xspeed = self.maxXSpeed
		end
		if love.keyboard.isDown('w') or love.keyboard.isDown('up') then
			self.yspeed = -self.maxYSpeed
		elseif love.keyboard.isDown('s') or love.keyboard.isDown('down') then
			self.yspeed = self.maxYSpeed
		end

		self.x = self.x + self.xspeed*dt
		self.y = self.y + self.yspeed*dt
	end
end

function playerfunctions:die()
	self.dead = true
	self.lives = self.lives - 1
	STATE.states.dead.load()
end

function playerfunctions:getPolygon()
	local p = {}
	for i=1,#self.imagePoints-1,2 do
		p[i] = self.imagePoints[i]+self.x
		p[i+1] = self.imagePoints[i+1] + self.y
	end
	return p
end

return playerfunctions