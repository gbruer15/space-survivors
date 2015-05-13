rectangle = {}
rectangle.__index = rectangle

function rectangle.make(width,height, x, y)
	local self = {}
	setmetatable(self,rectangle)
	self.width = width
	self.height = height

	self.x = x or self.width/2
	self.y = y or self.height/2


	return self
end


function rectangle:draw(mode,xoffset, yoffset)
	xoffset = xoffset or 0
	yoffset = yoffset or 0
	love.graphics.rectangle(mode,xoffset-self.x, yoffset-self.y, self.width,self.height)

end