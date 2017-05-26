
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


---------Images--------------
images = {}

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




------Music----------

music = {}

music.first = love.audio.newSource(GOOD_SOUNDS_PATH .. 'First.mp3', 'stream')


------Fonts----------

fonts = {}
fonts.basic = {}
local sizes = {10, 12, 14, 16, 20, 24, 36, 48, 60}

for i, v in ipairs(sizes) do
	fonts.basic[v] = love.graphics.newFont(v)
end


------Sounds----------

sounds = {}

sounds.chirp = love.audio.newSource(GOOD_SOUNDS_PATH .. 'chirp.wav', 'static')
sounds.explosion = love.audio.newSource(GOOD_SOUNDS_PATH .. 'explosion.wav', 'static')
sounds.enemies = love.audio.newSource(GOOD_SOUNDS_PATH .. 'enemies.wav', 'static')
sounds.whoosh = love.audio.newSource(GOOD_SOUNDS_PATH .. 'whoosh.wav', 'static')
sounds.dying_noises = love.audio.newSource(GOOD_SOUNDS_PATH .. 'dying_noises.wav', 'static')
sounds.winning_noises = love.audio.newSource(GOOD_SOUNDS_PATH .. 'winning_noises.wav', 'static')
sounds.sneeze = love.audio.newSource(GOOD_SOUNDS_PATH .. 'sneeze.mp3', 'static')

