local playerfunctions = {}
require('Game/missile')
function playerfunctions.make(att)
	local self = {}
	setmetatable(self, {__index = playerfunctions})

	self.x = window.width/2
	self.y = window.height/2
	self.drawBox = rectangle.make(70,125, self)

	self.collisionBox = rectangle.make(40,80,self)

	self.Image = images.spaceship
	self.drawBox.height = self.drawBox.width/self.Image.width*self.Image.height
	self.drawBox.dy = self.drawBox.height/2

	self.missiles = {}

	return self
end

function playerfunctions:update(dt)
	self.x,self.y = MOUSE.x,MOUSE.y
end

function playerfunctions:draw()
	love.graphics.setColor(255,255,255)
	--self.drawBox:draw('fill',self.x,self.y)
	love.graphics.draw(self.Image.image,self.drawBox:getLeft(),self.drawBox:getTop(),0,self.drawBox.width/self.Image.width, self.drawBox.height/self.Image.height)

	love.graphics.setColor(0,255,0,100)
	self.collisionBox:draw('line',self.x,self.y)	
end

function playerfunctions:fireMissile()
	table.insert(self.missiles,missile.make(self.x,self.y-self.drawBox.height/2, 350,-math.pi/2))
end



function playerfunctions:keypressed(key)

end

function playerfunctions:mousepressed(x,y,button)

end

return playerfunctions