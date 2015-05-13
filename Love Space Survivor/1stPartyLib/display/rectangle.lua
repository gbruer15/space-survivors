rectangle = {}
rectangle.__index = rectangle


--creates a rectangle with given width and height. 
--dx and dy are the displacement from the top left corner to the anchor, defaulted to center
function rectangle.make(width,height, ax,ay, dx, dy)
	local self = {}
	setmetatable(self,rectangle)
	self.width = width
	self.height = height

	self.dx = dx or self.width/2
	self.dy = dy or self.height/2

	if type(ax) == 'table' and ax.x and ax.y then
		self.anchor = ax
	else
		self.anchor = {x=ax or 0, y=ay or 0}
	end

	return self
end

function rectangle:getLeft()
	return self.anchor.x-self.dx
end

function rectangle:getTop()
	return self.anchor.y-self.dy
end

function rectangle:getRight()
	return self.anchor.x-self.dx+self.width
end

function rectangle:getBottom()
	return self.anchor.y-self.dy+self.height
end

function rectangle:getRect(returnTable)
	if returnTable then
		return {self:getLeft(),self:getTop(),self.width,self.height}
	end
	return self:getLeft(),self:getTop(),self.width,self.height
end


function rectangle:draw(mode)
	xoffset = xoffset or 0
	yoffset = yoffset or 0
	love.graphics.rectangle(mode or 'fill',self.anchor.x-self.dx, self.anchor.y-self.dy, self.width,self.height)

end