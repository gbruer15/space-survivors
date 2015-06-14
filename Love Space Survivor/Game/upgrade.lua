local upgrade = {}
upgrade.__index = upgrade
function upgrade.make(att)
	local self = {}
	setmetatable(self, upgrade)

	self.description = att.description or "This is an upgrade"
	self.name = att.name or 'No name'
	
	self.costFunction = att.costFunction
	self.upgradeFunction = att.upgradeFunction
	self.isMaxedOutFunction = att.isMaxedOutFunction

	self.maxValue = att.maxValue or false
	self.value = att.value or 1

	self.cost = att.cost or (self.costFunction and self.costFunction(self.value, self.cost)) or 1

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

function upgrade:increment(object)
	if self.upgradeFunction then
		self.upgradeFunction(object)
	end
	self.value = self.value + 1
	self.cost = self.costFunction(self.value,self.cost)
end

function upgrade:getMaxedOut()
	if self.maxValue then
		return self.value >= self.maxValue
	elseif self.isMaxedOutFunction then
		return self.isMaxedOutFunction()
	end
end

return upgrade