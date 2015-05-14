images = {}

local function getImage(name)
	local i = love.graphics.newImage(IMAGES_PATH .. name)
	return {image = i, width=i:getWidth(), height=i:getHeight()}

end


images.spaceship = getImage('spaceship.png')
images.enemySpaceship = getImage('enemyspaceship.png')
