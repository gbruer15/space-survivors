local state = {}

local enemy = require('Game/Enemy/enemy')
function state.load()
	state.states = {}
	state.states.intro = require("Game/States/playingStates/intro")
	state.states.playing = require("Game/States/playingStates/playing")
	state.states.dead = require("Game/States/playingStates/dead")

	state.state = state.states.intro

	for i,v in pairs(state.states) do
		v.load()
	end

	for i,v in pairs(state.states) do
		v.player = state.states.playing.player
	end


end

function state.update(dt)
	if state.state.update(dt) == 'start' then
		state.state = state.states.playing
	end

	if state.state.player.dead and state.state ~= state.states.dead then
		state.switchToDead()
	end
end

function state.draw()
	state.state.draw()
end

function state.keypressed(key)
	if state.state.keypressed then
		state.state.keypressed(key)
	end
end

function state.mousepressed(x,y,button)
	if state.state.mousepressed then
		if state.state.mousepressed(x,y,button) == 'restart' then
			state.state = state.states.playing
			--state.state.player.dead = false
			state.state.load()

			for i,v in pairs(state.states) do
				v.player = state.states.playing.player
			end
		end
	end
end

function state.switchToDead() 
	state.state = state.states.dead
	state.state.enemies = state.states.playing.enemies or {}
	state.state.enemyMissiles = state.states.playing.enemyMissiles or {}
	state.state.playerMissiles = state.states.playing.playerMissiles or {}
end

return state