local state = {}

function state.load()
	local text
	if STATE.player.lives > 1 then
		text = STATE.player.lives .. ' lives left.'
	elseif STATE.player.lives == 1 then
		text = STATE.player.lives .. ' life left.'
	end

	if STATE.player.lives > 0 then
		text = text .. ' Continue?'
	else
		text = 'You are completely dead.\nRestart level?'
	end
	state.boolBox = boolBox.make{
								centerx=window.width/2 
								,centery=window.height/2
								,titleText=text
								,boxColor={200,0,0,155}
								,trueText = 'Yes'
								,falseText = 'No'
							}
	-- sounds.dying_noises:play()
end

function state.update(dt)
	state.boolBox:update(dt)
end

function state.draw()
	state.boolBox:draw()
end

function state.keypressed(key)
end

function state.mousepressed(x,y,button)
	state.boolBox:mousepressed(x,y,button)
	if state.boolBox.value then
		STATE.enemies = {}
		STATE.enemyMissiles = {}
		STATE.player.missiles = {}
		STATE.player.dead = false

		if STATE.player.lives > 0 then
			STATE.state = STATE.states.paused
			if STATE.level.onDeath then
				STATE.level.onDeath()
			end
			STATE.player.x = STATE.camera.x
			STATE.player.y = STATE.camera.y
		else
			STATE.player.levelCash = 0
			STATE.player.levelScore = 0
			STATE.player.levelKills = 0

			STATE.state = STATE.states.intro
			STATE.state.load()
			STATE.level.reload()
		end
	elseif state.boolBox.value == false then
		STATE = require('Game/States/levelselect')
		STATE.load()
	end
end

return state