powerup = {}
powerup.__index = powerup

powerup.types = {
	megaLaser 	= {	name = 'L'
					,apply = function(p) 
							p.megaLasers = p.megaLasers + 1 
							return true 
						end
				}
	,shield		= {	name = 'S'
					,apply = function (p)
							if p.shield < 5 then
								p.shield = p.shield + 1
								return true
							end
							return false
						end
				}

}
function powerup.make(att)
	local self = {}
	setmetatable(self, powerup)

	self.radius = att.radius or 15

	local radius = 10
	angle = 0
	self.points = {}
	for i = 1, 7, 2 do
		angle = angle + math.pi/2
		self.points[i] = radius*math.cos(angle)
		self.points[i+1] = radius*math.sin(angle) 
	end

	self.x = att.x or 0
	self.y = att.y or 0

	self.xspeed = att.xspeed or 0
	self.yspeed = att.yspeed or 0

	self.type = powerup.types[att.type] or error('Bad powerup type given: ' .. tostring(att.type))

	self.polygon = {}
	self:updatePolygon()
	return self
end

function powerup:update(dt)
	self.x = self.x + self.xspeed*dt
	self.y = self.y + self.yspeed*dt

	self:updatePolygon()
end

function powerup:draw()
	love.graphics.setColor(0,0,200)
	love.graphics.polygon('fill', self.polygon)

	love.graphics.setColor(255,255,255)
	love.graphics.printf(self.type.name, self.x - self.radius, self.y-self.radius/2, self.radius*2, 'center')
end

function powerup:updatePolygon()
	for i = 1, #self.points, 2 do
		self.polygon[i] = self.points[i] + self.x
	end
	for i = 2, #self.points, 2 do
		self.polygon[i] = self.points[i] + self.y
	end
end

function powerup:isHittingRectangle(l, t, w, h)
	return collision.polygons(self.polygon, {l,t, l+w,t, l+w,t+h, l, t+h})
end

function powerup:apply(player)
	return self.type.apply(player)
end