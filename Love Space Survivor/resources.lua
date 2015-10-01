images = {}

local function getImage(name)
	local i = love.graphics.newImage(IMAGES_PATH .. name)
	return {image = i, width=i:getWidth(), height=i:getHeight()}
end

local function getGoodImage(name)
	local i = love.graphics.newImage(GOOD_IMAGES_PATH .. name)
	return {image = i, width=i:getWidth(), height=i:getHeight()}
end

local function getGoodImagePoints(name)
	return require(GOOD_IMAGES_PATH..name)
end
images.spaceship = getGoodImage('playerSpaceship.png')
images.spaceshipPoints = getGoodImagePoints('playerSpaceshipPoints')

images.enemySpaceship = getImage('enemyspaceship.png')

images.greenLaser = getGoodImage('laserGreen.png')
images.greenLaserTop = getGoodImage('laserGreenTop.png')
images.greenLaserMiddle = getGoodImage('laserGreenMiddle.png')
images.greenLaserBottom = getGoodImage('laserGreenBottom.png')
images.greenLaserBottomSquished = getGoodImage('laserGreenBottomSquished.png')

images.redLaser = getGoodImage('laserRed.png')

images.boss = getImage('big boss.png')

images.basicOutline = getImage('outline1.png')
images.basicOutline90 = getImage('outline1-90.png')

images.basicOutlineCorner = getImage('outline1-corner.png')
images.basicOutlineStraight = getImage('outline1-straight.png')

images.moveLeftAnimation = getImage('moveLeftSprites.png')
images.moveLeftAnimation.spriteWidth = 168
images.moveLeftAnimation.spriteHeight = images.moveLeftAnimation.height

images.tinySpiral = getImage('tinySpiral.png')

local outline = require('1stPartyLib/display/outline')
outlines = {}
outlines.basicOutline = outline.make{
							corner = images.basicOutlineCorner.image
							,straight = images.basicOutlineStraight.image
							,lineWidth = 5
						}
