local state = {}

local enemy = require('Game/Enemy/enemy')
function state.load()
	state.boolBox = boolBox.make{
								centerx=window.width/2 
								,centery=window.height/2
								,titleText='Try again?'
								,boxColor={200,0,0,100}


							}
end

function state.update(dt)
	state.boolBox:update(dt)
end

function state.draw()
	love.graphics.setColor(255,255,0)
	for i,v in ipairs(state.enemyMissiles) do
		v:draw()
	end

	for i,v in ipairs(state.enemies) do
		v:draw(true,'line')
	end

	love.graphics.setColor(255,0,0)
	for i,v in ipairs(state.playerMissiles) do
		v:draw()
	end
	state.player:draw(true,'fill',{0,100,0,200})
	state.boolBox:draw()
end

function state.keypressed(key)
end

function state.mousepressed(x,y,button)
	state.boolBox:mousepressed(x,y,button)
	if state.boolBox.value then
		return 'restart'
	end
end

return state