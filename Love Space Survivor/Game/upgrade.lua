local upgrade = {}
upgrade.__index = upgrade
function upgrade.make(att)
	local self = {}
	setmetatable(self, upgrade)

	self.description = att.description or "This is an upgrade"

	
	self.costFunction = att.costFunction
	

	self.maxValue = att.maxValue or false
	self.value = att.value or 1

	self.cost = att.cost or 1

	if att.initialValue and att.initialValue > 0 then
		for i=1,att.initialValue do 
			self:increment()
		end
	end

	return self
end

function upgrade:getCost()
	return self.cost
end

function upgrade:increment()
	self.value = self.value + 1
	self.cost = self.costFunction(self.value,self.cost)
end

return upgrade