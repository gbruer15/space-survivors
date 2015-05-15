images = {}

local function getImage(name)
	local i = love.graphics.newImage(IMAGES_PATH .. name)
	return {image = i, width=i:getWidth(), height=i:getHeight()}

end


images.spaceship = getImage('spaceship.png')
images.enemySpaceship = getImage('enemyspaceship.png')

images.basicOutline = getImage('outline1.png')
images.basicOutline90 = getImage('outline1-90.png')

images.basicOutlineCorner = getImage('outline1-corner.png')
images.basicOutlineStraight = getImage('outline1-straight.png')