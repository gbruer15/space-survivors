local outline = {}
outline.__index = outline

function outline.make(att)
	local self = {}
	setmetatable(self,outline)

	self.corner = att.corner
	self.cIWidth = self.corner:getWidth()
	self.cIHeight = self.corner:getHeight()

	self.straight = att.straight
	self.sIWidth = self.straight:getWidth()
	self.sIHeight = self.straight:getHeight()

	self.lineWidth = att.lineWidth

	self.scale = self.lineWidth/self.sIHeight

	self.cScale = self.scale


	self.cWidth = self.cIWidth*self.cScale
	return self
end


function outline:draw(x,y,width,height)

	local straightWidth = width - self.cWidth*2
	local straightHeight=height - self.cWidth*2
	--top left corner
	love.graphics.draw(self.corner,x,y,0,self.cScale,self.cScale)

	love.graphics.draw(self.straight,x+self.cWidth,y,0, straightWidth/self.sIWidth,self.scale)


	--top right corner
	love.graphics.draw(self.corner,x+width,y,math.pi/2,self.cScale,self.cScale)

	love.graphics.draw(self.straight,x+width,y+self.cWidth,math.pi/2, straightHeight/self.sIWidth,self.scale)


	--bottom right corner
	love.graphics.draw(self.corner,x+width,y+height,math.pi,self.cScale,self.cScale)

	love.graphics.draw(self.straight,x+width-self.cWidth,y+height,math.pi, straightWidth/self.sIWidth,self.scale)


	--bottom left corner
	love.graphics.draw(self.corner,x,y+height,-math.pi/2,self.cScale,self.cScale)

	love.graphics.draw(self.straight,x,y+height-self.cWidth,-math.pi/2, straightHeight/self.sIWidth,self.scale)

end

return outline