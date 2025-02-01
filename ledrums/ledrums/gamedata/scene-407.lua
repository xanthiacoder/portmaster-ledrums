-- scene-407
-- scene name : LEDrums (Slowcore)
-- scene functions are :
-- .init() for one-time initialization of stuff
-- .input() for all the key mapping
-- .start() to kickstart the scene
-- .update() for frame by frame activity
-- .draw() for the draw state

local sceneNumber = 407

-- music data for this scene

-- filenames of samples to load
local sample = {
	[1] = "Slowcore-Cymbal.wav",
	[2] = "Slowcore-Drone1.wav",
	[3] = "Slowcore-Drum1.wav",
	[4] = "Slowcore-Drum2.wav",
	[5] = "Slowcore-Hihat.wav",
	[6] = "Slowcore-Drum3.wav",
	[7] = "Slowcore-Drone2.wav",
	[8] = "Slowcore-Crash.wav",
	}

local seq = {}
-- define 4 loops
seq.loop = {
	[1] = {},
	[2] = {},
	[3] = {},
	[4] = {},
	}
-- define 8 tracks
for i = 1,4 do	
seq.loop[i].track = {
	[1] = {},
	[2] = {},
	[3] = {},
	[4] = {},
	[5] = {},
	[6] = {},
	[7] = {},
	[8] = {},
	}
-- define default tempo for each of the 4 loops
seq.loop[i].tempo = 120
end
-- define 4 ticks
for i = 1,4 do
for j = 1,8 do
seq.loop[i].track[j].tick = {
	[1] = {},
	[2] = {},
	[3] = {},
	[4] = {},
	}
end
end
-- define 4 tocks
for i = 1,4 do
for j = 1,8 do
for k = 1,4 do
seq.loop[i].track[j].tick[k].tock = {
	[1] = "-",
	[2] = "-",
	[3] = "-",
	[4] = "-",
	}
end
end
end

local ledAlpha = {}
ledAlpha[1] = 1 -- the transparency of 1st led
ledAlpha[2] = 0 -- the transparency of 2st led
ledAlpha[3] = 0 -- the transparency of 3st led
ledAlpha[4] = 0 -- the transparency of 4st led

local currentLoop = 1 -- currently selected loop
song.tempo = seq.loop[currentLoop].tempo

local trackVolumeMeter = {} -- the volume meter for each track, range 0 .. 100
for i = 1,8 do
	trackVolumeMeter[i] = 0
end

local tickChange = clock.tick -- to tell when the tick has changed
local tockChange = clock.tock -- to tell when the tock has changed
local tapTempo = love.timer.getTime() -- init to detect delta to change tempo

-- graphical overlay for this scene's help
local helpTextOverlay = love.graphics.newImage("bgart/transparent-black-50.png")
local HDhelpTextOverlay = love.graphics.newImage("bgart/HD-transparent-black-50.png")

-- graphic highlight for beat editor
local beatHighlight = love.graphics.newImage("pic/beat-highlight.png")
local HDbeatHighlight = love.graphics.newImage("pic/HD-beat-highlight.png")

-- graphics for samples triggered display
local orangeBar = love.graphics.newImage("pic/orange-bar.png")
local HDorangeBar = love.graphics.newImage("pic/HD-orange-bar.png")

-- LEDs for indicators
local greenLED = love.graphics.newImage("pic/green-led.png")
local HDgreenLED = love.graphics.newImage("pic/HD-green-led.png")
local greyLED = love.graphics.newImage("pic/grey-led.png")
local HDgreyLED = love.graphics.newImage("pic/HD-grey-led.png")

-- other indicators
local indicatorHalfTime = love.graphics.newImage("pic/halftime.png")
local indicatorRec = love.graphics.newImage("pic/rec.png")
local indicatorPlay = love.graphics.newImage("pic/play.png")

local K = {}

local helpText = ""


local function clearLoop(loop)

local j = 1
local k = 1

for j = 1,8 do
for k = 1,4 do
seq.loop[loop].track[j].tick[k].tock = {
	[1] = "-",
	[2] = "-",
	[3] = "-",
	[4] = "-",
	}
end
end

game.tooltip = "Current loop data cleared."
end -- clearLoop


local function saveData()

	local i = 1
	local j = 1
	local tick = 1
	local tock = 1
	
	-- using LUA IO to write data for universal compatibility
	local f = io.open(love.filesystem.getSaveDirectory().."//seqs/"..sceneNumber.."-autosave-tempo.txt", "w")
	f:write(seq.loop[1].tempo, "\n")
	f:write(seq.loop[2].tempo, "\n")
	f:write(seq.loop[3].tempo, "\n")
	f:write(seq.loop[4].tempo)
	f:close()

	-- save sceneNumber
	f = io.open(love.filesystem.getSaveDirectory().."//autosaves/currentscene.txt", "w")
	f:write(sceneNumber)
	f:close()

	-- save loop1 data
	f = io.open(love.filesystem.getSaveDirectory().."//seqs/"..sceneNumber.."-autosave-loop1.txt", "w")
	for j = 1,8 do
	tick = 1
	tock = 1
	for i = 1,16 do
		f:write(seq.loop[1].track[j].tick[tick].tock[tock])
		tock = tock + 1
		if tock == 5 then
			tick = tick + 1
			tock = 1
		end		
	end -- end writing single track
	if j < 8 then -- if not the last track
		f:write("\n") -- go to next line for next track
	end
	end -- end writing all tracks
	f:close()

	-- save loop2 data
	f = io.open(love.filesystem.getSaveDirectory().."//seqs/"..sceneNumber.."-autosave-loop2.txt", "w")
	for j = 1,8 do
	tick = 1
	tock = 1
	for i = 1,16 do
		f:write(seq.loop[2].track[j].tick[tick].tock[tock])
		tock = tock + 1
		if tock == 5 then
			tick = tick + 1
			tock = 1
		end		
	end -- end writing single track
	if j < 8 then -- if not the last track
		f:write("\n") -- go to next line for next track
	end
	end -- end writing all tracks
	f:close()

	-- save loop3 data
	f = io.open(love.filesystem.getSaveDirectory().."//seqs/"..sceneNumber.."-autosave-loop3.txt", "w")
	for j = 1,8 do
	tick = 1
	tock = 1
	for i = 1,16 do
		f:write(seq.loop[3].track[j].tick[tick].tock[tock])
		tock = tock + 1
		if tock == 5 then
			tick = tick + 1
			tock = 1
		end		
	end -- end writing single track
	if j < 8 then -- if not the last track
		f:write("\n") -- go to next line for next track
	end
	end -- end writing all tracks
	f:close()

	-- save loop4 data
	f = io.open(love.filesystem.getSaveDirectory().."//seqs/"..sceneNumber.."-autosave-loop4.txt", "w")
	for j = 1,8 do
	tick = 1
	tock = 1
	for i = 1,16 do
		f:write(seq.loop[4].track[j].tick[tick].tock[tock])
		tock = tock + 1
		if tock == 5 then
			tick = tick + 1
			tock = 1
		end		
	end -- end writing single track
	if j < 8 then -- if not the last track
		f:write("\n") -- go to next line for next track
	end
	end -- end writing all tracks
	f:close()

	game.tooltip = "Scene "..sceneNumber.." data saved at " .. math.floor(game.time + love.timer.getTime())

end -- saveData


-- K.init is for loading assets for the scene (done only once at game load)
function K.init()

	-- background to display
	if game.screenHD then
		bgart[sceneNumber] = love.graphics.newImage("bgart/HD-"..sceneNumber..".jpg") -- 1280x720
	else
		bgart[sceneNumber] = love.graphics.newImage("bgart/"..sceneNumber..".jpg") -- 640x480
	end

	-- help text to appear
	help[sceneNumber] = ""
	
end -- K.init


-- K.start is to init anything when scene starts, can be reloaded multiple times
function K.start()

	-- load scene-specific sounds
	sfx[1] = love.audio.newSource("sfx/"..sample[1], "static")
	sfx[2] = love.audio.newSource("sfx/"..sample[2], "static")
	sfx[3] = love.audio.newSource("sfx/"..sample[3], "static")
	sfx[4] = love.audio.newSource("sfx/"..sample[4], "static")
	sfx[5] = love.audio.newSource("sfx/"..sample[5], "static")
	sfx[6] = love.audio.newSource("sfx/"..sample[6], "static")
	sfx[7] = love.audio.newSource("sfx/"..sample[7], "static")
	sfx[8] = love.audio.newSource("sfx/"..sample[8], "static")


	local i = 1
	local j = 1
	local h = 1
	local tick = 1
	local tock = 1
	local track = {}
	-- read all autosave tempo data
	local f = io.input (love.filesystem.getSaveDirectory().."//seqs/"..sceneNumber.."-autosave-tempo.txt")
	i = 1
	for line in f:lines() do
		seq.loop[i].tempo = line
		i = i + 1
	end
	f:close()
	-- set tempo according to loaded values
	song.tempo = seq.loop[currentLoop].tempo

	-- read all autosave loop data
	f = io.input (love.filesystem.getSaveDirectory().."//seqs/"..sceneNumber.."-autosave-loop1.txt")
	i = 1
	for line in f:lines() do
		track[i] = line
		i = i + 1
	end
	f:close()

	for j = 1,8 do -- read 8 tracks
	tick = 1
	tock = 1
	for h = 1,16 do -- read 16 sub-beats
		seq.loop[1].track[j].tick[tick].tock[tock] = string.sub(track[j], h, h)
		tock = tock + 1
		if tock == 5 then
			tick = tick + 1
			tock = 1
		end
	end -- end read of 16 sub-beats
	end -- end read of 8 tracks

	f = io.input (love.filesystem.getSaveDirectory().."//seqs/"..sceneNumber.."-autosave-loop2.txt")
	i = 1
	for line in f:lines() do
		track[i] = line
		i = i + 1
	end
	f:close()

	for j = 1,8 do -- read 8 tracks
	tick = 1
	tock = 1
	for h = 1,16 do -- read 16 sub-beats
		seq.loop[2].track[j].tick[tick].tock[tock] = string.sub(track[j], h, h)
		tock = tock + 1
		if tock == 5 then
			tick = tick + 1
			tock = 1
		end
	end -- end read of 16 sub-beats
	end -- end read of 8 tracks

	f = io.input (love.filesystem.getSaveDirectory().."//seqs/"..sceneNumber.."-autosave-loop3.txt")
	i = 1
	for line in f:lines() do
		track[i] = line
		i = i + 1
	end
	f:close()

	for j = 1,8 do -- read 8 tracks
	tick = 1
	tock = 1
	for h = 1,16 do -- read 16 sub-beats
		seq.loop[3].track[j].tick[tick].tock[tock] = string.sub(track[j], h, h)
		tock = tock + 1
		if tock == 5 then
			tick = tick + 1
			tock = 1
		end
	end -- end read of 16 sub-beats
	end -- end read of 8 tracks

	f = io.input (love.filesystem.getSaveDirectory().."//seqs/"..sceneNumber.."-autosave-loop4.txt")
	i = 1
	for line in f:lines() do
		track[i] = line
		i = i + 1
	end
	f:close()

	for j = 1,8 do -- read 8 tracks
	tick = 1
	tock = 1
	for h = 1,16 do -- read 16 sub-beats
		seq.loop[4].track[j].tick[tick].tock[tock] = string.sub(track[j], h, h)
		tock = tock + 1
		if tock == 5 then
			tick = tick + 1
			tock = 1
		end
	end -- end read of 16 sub-beats
	end -- end read of 8 tracks

end -- K.start


-- K.input is for keymapping
function K.input()


function love.gamepadpressed(joystick, button)

	-- detecting combos when buttonCooldown == 0
	if buttonCooldown == 0 then
		-- SELECT + dpleft
		if gamepad:isGamepadDown("back") and gamepad:isGamepadDown("dpleft") then
			-- switch scene QUIT
			buttonCooldown = 15 -- sets a delay before accepting input again
		    saveData() -- force scene autosave
		    scene[999].input() -- change input key-map to 999's
		    scene[999].start() -- change input key-map to 999's
		    scene.current = 999 -- change to exitscreen scene
			scene.previous = sceneNumber -- put current scene into scene history
		end
		-- R1 + Left Face Bn
		if gamepad:isGamepadDown("rightshoulder") and gamepad:isGamepadDown("x") then
			buttonCooldown = 15 -- sets a delay before accepting input again
	      	saveData() -- force scene autosave
	      	scene[406].input() -- change input key-map to 406's
	      	scene[406].start() -- run 406 start process
	      	scene.current = 406 -- change to 406 scene
			scene.previous = sceneNumber -- put current scene into scene history
		end
		-- R1 + Right Face Bn
		if gamepad:isGamepadDown("rightshoulder") and gamepad:isGamepadDown("b") then
			buttonCooldown = 15 -- sets a delay before accepting input again
	      	saveData() -- force scene autosave
	      	scene[408].input() -- change input key-map to 408's
	      	scene[408].start() -- run 408 start process
	      	scene.current = 408 -- change to 408 scene
			scene.previous = sceneNumber -- put current scene into scene history
		end		
		-- L1 + START
		if gamepad:isGamepadDown("leftshoulder") and gamepad:isGamepadDown("start") then
			buttonCooldown = 15 -- sets a delay before accepting input again
			-- toggle Play/Rec mode
			if song.recording then
				song.recording = false
			else
				song.recording = true
			end	
		end
		-- L1 + dpup
		if gamepad:isGamepadDown("leftshoulder") and gamepad:isGamepadDown("dpup") then
			buttonCooldown = 15 -- sets a delay before accepting input again
			saveData()
			currentLoop = 1
			song.tempo = seq.loop[currentLoop].tempo
		end
		-- L1 + dpleft
		if gamepad:isGamepadDown("leftshoulder") and gamepad:isGamepadDown("dpleft") then
			buttonCooldown = 15 -- sets a delay before accepting input again
			saveData()
			currentLoop = 2
			song.tempo = seq.loop[currentLoop].tempo
		end
		-- L1 + dpdown
		if gamepad:isGamepadDown("leftshoulder") and gamepad:isGamepadDown("dpdown") then
			buttonCooldown = 15 -- sets a delay before accepting input again
			saveData()
			currentLoop = 3
			song.tempo = seq.loop[currentLoop].tempo
		end
		-- L1 + dpright
		if gamepad:isGamepadDown("leftshoulder") and gamepad:isGamepadDown("dpright") then
			buttonCooldown = 15 -- sets a delay before accepting input again
			saveData()
			currentLoop = 4
			song.tempo = seq.loop[currentLoop].tempo
		end
		-- L1 + Y (top face)
		if gamepad:isGamepadDown("leftshoulder") and gamepad:isGamepadDown("y") then
			buttonCooldown = 15 -- sets a delay before accepting input again
			-- toggle 1/2 time tempo
			if song.halfTime then
		  		song.halfTime = false
			else
		  		song.halfTime = true
			end
		end
		-- L1 + X (left face)
		if gamepad:isGamepadDown("leftshoulder") and gamepad:isGamepadDown("x") then
			buttonCooldown = 6 -- sets a delay before accepting input again
		    -- reduce song's tempo
			seq.loop[currentLoop].tempo = seq.loop[currentLoop].tempo - 1
			song.tempo = seq.loop[currentLoop].tempo      	
		end
		-- L1 + A (bottom face)
		if gamepad:isGamepadDown("leftshoulder") and gamepad:isGamepadDown("a") then
			buttonCooldown = 6 -- sets a delay before accepting input again
			-- tapTempo detection
			if (love.timer.getTime() - tapTempo) > 2 then
				-- new attempt to tap tempo detected, recalibrate
				tapTempo = love.timer.getTime()
			else
				seq.loop[currentLoop].tempo = math.floor(60 / (love.timer.getTime() - tapTempo))
				song.tempo = seq.loop[currentLoop].tempo
		    	tapTempo = love.timer.getTime() -- init for the next detection
			end
		end
		-- L1 + B (right face)
		if gamepad:isGamepadDown("leftshoulder") and gamepad:isGamepadDown("b") then
			buttonCooldown = 6 -- sets a delay before accepting input again
		    -- increase song's tempo
			seq.loop[currentLoop].tempo = seq.loop[currentLoop].tempo + 1
			song.tempo = seq.loop[currentLoop].tempo
		end
		-- R1 + dpup
		if gamepad:isGamepadDown("rightshoulder") and gamepad:isGamepadDown("dpup") then
			buttonCooldown = 15 -- sets a delay before accepting input again
			-- rstk UP detected to clear loop, but no SELECT held
			-- display instruction for CLEAR
			game.tooltip = "Hold SELECT + R1 + UP to clear loop"
		end
		if gamepad:isGamepadDown("rightshoulder") and gamepad:isGamepadDown("dpup") and gamepad:isGamepadDown("back") then
			-- SELECT + rstk UP detected to clear loop
			clearLoop(currentLoop)
		end

		-- R1 + dpleft
		if gamepad:isGamepadDown("rightshoulder") and gamepad:isGamepadDown("dpleft") then
			buttonCooldown = 15 -- sets a delay before accepting input again
			-- move playhead left
			-- Move Track beat selection backwards
			if (clock.tick * clock.tock) > 1 then
				clock.tock = clock.tock - 1
				if clock.tock == 0 then
					clock.tick = clock.tick - 1
					clock.tock = 4
				end
			else
				-- do this when at 1.1, cycle to the end
				clock.tick = 4
				clock.tock = 4
			end
		end
		-- R1 + dpdown
		if gamepad:isGamepadDown("rightshoulder") and gamepad:isGamepadDown("dpdown") then
			buttonCooldown = 15 -- sets a delay before accepting input again
			-- toggle Play | Rec mode
			-- toggle Play/Rec mode
			if song.recording then
				song.recording = false
			else
				song.recording = true
			end	
		end
		-- R1 + dpright
		if gamepad:isGamepadDown("rightshoulder") and gamepad:isGamepadDown("dpright") then
			buttonCooldown = 15 -- sets a delay before accepting input again
			-- move playhead right
			-- Move Track beat selection forwards
			if (clock.tick * clock.tock) < 16 then
				clock.tock = clock.tock + 1
				if clock.tock == 5 then
					clock.tick = clock.tick + 1
					clock.tock = 1
				end
			else
				-- do this when at 4.4, cycle back to the beginning
				clock.tick = 1
				clock.tock = 1
			end
		end
	end

	-- detecting D-Pad
	if button == "dpup" and buttonCooldown == 0 then
      -- D-Pad UP pressed
      love.audio.stop(sfx[1])
      love.audio.play(sfx[1])
	  trackVolumeMeter[1] = 50
	  if song.recording then -- write data only if recording mode
	    if seq.loop[currentLoop].track[1].tick[clock.tick].tock[clock.tock] == "-" then
			seq.loop[currentLoop].track[1].tick[clock.tick].tock[clock.tock] = 7
	  	else
      		seq.loop[currentLoop].track[1].tick[clock.tick].tock[clock.tock] = "-"
      	end
      	saveData()
      end
	end
	if button == "dpleft" and buttonCooldown == 0 then
      -- D-Pad LEFT pressed
      love.audio.stop(sfx[2])
      love.audio.play(sfx[2])
	  trackVolumeMeter[2] = 50
	  if song.recording then -- write data only if recording mode
	      if seq.loop[currentLoop].track[2].tick[clock.tick].tock[clock.tock] == "-" then
	      	seq.loop[currentLoop].track[2].tick[clock.tick].tock[clock.tock] = 7
		  else
	      	seq.loop[currentLoop].track[2].tick[clock.tick].tock[clock.tock] = "-"
	      end
		  saveData()
	  end
	end
	if button == "dpdown" and buttonCooldown == 0 then
      -- D-Pad DOWN pressed
      love.audio.stop(sfx[3])
      love.audio.play(sfx[3])
	  trackVolumeMeter[3] = 50
	  if song.recording then -- write data only if recording mode
	      if seq.loop[currentLoop].track[3].tick[clock.tick].tock[clock.tock] == "-" then
	      	seq.loop[currentLoop].track[3].tick[clock.tick].tock[clock.tock] = 7
		  else
	      	seq.loop[currentLoop].track[3].tick[clock.tick].tock[clock.tock] = "-"
	      end
	      saveData()
	  end
	end
	if button == "dpright" and buttonCooldown == 0 then
      -- D-Pad RIGHT pressed
      love.audio.stop(sfx[4])
      love.audio.play(sfx[4])
	  trackVolumeMeter[4] = 50
	  if song.recording then -- write data only if recording mode
	      if seq.loop[currentLoop].track[4].tick[clock.tick].tock[clock.tock] == "-" then
	      	seq.loop[currentLoop].track[4].tick[clock.tick].tock[clock.tock] = 7
		  else
	      	seq.loop[currentLoop].track[4].tick[clock.tick].tock[clock.tock] = "-"
	      end
	      saveData()
	  end
	end

	-- detecting Face Buttons, Top (Y), Left (X), Bottom (A), Right (B)
	if button == "y" and buttonCooldown == 0 then
      -- Top Button pressed
      love.audio.stop(sfx[8])
      love.audio.play(sfx[8])
	  trackVolumeMeter[8] = 50
	  if song.recording then -- write data only if recording mode
	      if seq.loop[currentLoop].track[8].tick[clock.tick].tock[clock.tock] == "-" then
	      	seq.loop[currentLoop].track[8].tick[clock.tick].tock[clock.tock] = 7
		  else
	      	seq.loop[currentLoop].track[8].tick[clock.tick].tock[clock.tock] = "-"
	      end
	      saveData()
	  end
	end
	if button == "x" and buttonCooldown == 0 then
      -- Left Button pressed
      love.audio.stop(sfx[5])
      love.audio.play(sfx[5])
	  trackVolumeMeter[5] = 50
	  if song.recording then -- write data only if recording mode
	      if seq.loop[currentLoop].track[5].tick[clock.tick].tock[clock.tock] == "-" then
	      	seq.loop[currentLoop].track[5].tick[clock.tick].tock[clock.tock] = 7
		  else
	      	seq.loop[currentLoop].track[5].tick[clock.tick].tock[clock.tock] = "-"
	      end
	      saveData()
	  end
	end
	if button == "a" and buttonCooldown == 0 then
      -- Bottom Button pressed
      love.audio.stop(sfx[6])
      love.audio.play(sfx[6])
	  trackVolumeMeter[6] = 50
	  if song.recording then -- write data only if recording mode
	      if seq.loop[currentLoop].track[6].tick[clock.tick].tock[clock.tock] == "-" then
	      	seq.loop[currentLoop].track[6].tick[clock.tick].tock[clock.tock] = 7
		  else
	      	seq.loop[currentLoop].track[6].tick[clock.tick].tock[clock.tock] = "-"
	      end
	      saveData()
	  end
	end
	if button == "b" and buttonCooldown == 0 then
      -- Right Button pressed
      love.audio.stop(sfx[7])
      love.audio.play(sfx[7])
	  trackVolumeMeter[7] = 50
	  if song.recording then -- write data only if recording mode
	      if seq.loop[currentLoop].track[7].tick[clock.tick].tock[clock.tock] == "-" then
	      	seq.loop[currentLoop].track[7].tick[clock.tick].tock[clock.tock] = 7
		  else
	      	seq.loop[currentLoop].track[7].tick[clock.tick].tock[clock.tock] = "-"
	      end
	      saveData()
	  end
	end

	if button == "start" and buttonCooldown == 0 then
      -- START pressed
      clock.tick = 1
      clock.tock = 1
      clock.time = love.timer.getTime()
	  clock.lapTock = clock.time
      if song.playing == false then
      	song.playing = true
      	-- start playing tracks
		for i = 1,8 do
			if seq.loop[currentLoop].track[i].tick[clock.tick].tock[clock.tock] ~= "-" then
		      love.audio.stop(sfx[i])
		      love.audio.play(sfx[i])
			end
		end
      else
      	song.playing = false
      end
	end

end -- love.gamepadpressed


function love.gamepadreleased(joystick, button)

	-- detecting Face Buttons, Top (Y), Left (X), Bottom (A), Right (B)
	if button == "y" then
      -- Top Button released
	end
	if button == "x" then
      -- Left Button released
	end
	if button == "a" then
      -- Bottom Button released
	end
	if button == "b" then
      -- Right Button released
	end

end -- love.gampadreleased


function love.gamepadaxis(joystick, axis, value)

	-- detecting L2 / R2 
	if gamepad:getGamepadAxis("triggerleft") == 1 then
      -- L2 pressed
	end
	if gamepad:getGamepadAxis("triggerright") == 1 then
      -- R2 pressed
	end

	if axis == "leftx" then
		-- SELECT + lstk LEFT
		if (gamepad:getGamepadAxis("leftx") < -0.8) and gamepad:isGamepadDown("back") and buttonCooldown == 0 then
			-- SELECT + lstk LEFT detected to switch scene QUIT
			buttonCooldown = 15 -- sets a delay before accepting input again
		    saveData() -- force scene autosave
		    scene[999].input() -- change input key-map to 999's
		    scene[999].start() -- change input key-map to 999's
		    scene.current = 999 -- change to exitscreen scene
			scene.previous = sceneNumber -- put current scene into scene history
		end
	end
	if axis == "leftx" then
		-- lstk LEFT to slow down tempo
		if (gamepad:getGamepadAxis("leftx") < -0.8) and not gamepad:isGamepadDown("back") and buttonCooldown == 0 then
			-- lstk LEFT detected
			buttonCooldown = 15 -- sets a delay before accepting input again
		    -- reduce song's tempo
			seq.loop[currentLoop].tempo = seq.loop[currentLoop].tempo - 1
			song.tempo = seq.loop[currentLoop].tempo      	
		end
	end	
	if axis == "leftx" then
		-- lstk RIGHT to speed up tempo
		if (gamepad:getGamepadAxis("leftx") > 0.8) and buttonCooldown == 0 then
			-- lstk RIGHT detected
			buttonCooldown = 15 -- sets a delay before accepting input again
		    -- increase song's tempo
			seq.loop[currentLoop].tempo = seq.loop[currentLoop].tempo + 1
			song.tempo = seq.loop[currentLoop].tempo
		end
	end	

	if axis == "lefty" then
		if (gamepad:getGamepadAxis("lefty") < -0.8) and buttonCooldown == 0 then
			-- lstk UP detected
			buttonCooldown = 15
			-- toggle 1/2 time tempo
		  if song.halfTime then
		  	song.halfTime = false
		  else
		  	song.halfTime = true
		  end
		end
		if (gamepad:getGamepadAxis("lefty") > 0.8) and buttonCooldown == 0 then
			-- lstk DOWN detected
			buttonCooldown = 15 -- sets a delay before accepting input again
	      -- tapTempo detection
		  if (love.timer.getTime() - tapTempo) > 2 then
			 -- new attempt to tap tempo detected, recalibrate
		     tapTempo = love.timer.getTime()
		  else
			seq.loop[currentLoop].tempo = math.floor(60 / (love.timer.getTime() - tapTempo))
			song.tempo = seq.loop[currentLoop].tempo
		    tapTempo = love.timer.getTime() -- init for the next detection
		  end

		end
	end
	
	if axis == "rightx" then
		if (gamepad:getGamepadAxis("rightx") < -0.8) and buttonCooldown == 0 then
			-- rstk LEFT detected to move playhead left
			buttonCooldown = 15
			-- Move Track beat selection backwards
			if (clock.tick * clock.tock) > 1 then
				clock.tock = clock.tock - 1
				if clock.tock == 0 then
					clock.tick = clock.tick - 1
					clock.tock = 4
				end
			else
				-- do this when at 1.1, cycle to the end
				clock.tick = 4
				clock.tock = 4
			end
		end
		if (gamepad:getGamepadAxis("rightx") > 0.8) and buttonCooldown == 0 then
			-- rstk RIGHT detected to move playhead right
			buttonCooldown = 15
			-- Move Track beat selection forwards
			if (clock.tick * clock.tock) < 16 then
				clock.tock = clock.tock + 1
				if clock.tock == 5 then
					clock.tick = clock.tick + 1
					clock.tock = 1
				end
			else
				-- do this when at 4.4, cycle back to the beginning
				clock.tick = 1
				clock.tock = 1
			end
		end
	end

	if axis == "righty" then
		if (gamepad:getGamepadAxis("righty") < -0.8) and not gamepad:isGamepadDown("back") then
			-- rstk UP detected to clear loop, but no SELECT held
			  -- display instruction for CLEAR
			  game.tooltip = "Hold SELECT and Right-Stick UP to clear loop"
		end
		if (gamepad:getGamepadAxis("righty") < -0.8) and gamepad:isGamepadDown("back") then
			-- SELECT + rstk UP detected to clear loop
			clearLoop(currentLoop)
		end
		if (gamepad:getGamepadAxis("righty") > 0.8) and buttonCooldown == 0 then
			-- rstk DOWN to toggle Play | Rec mode
			buttonCooldown = 15
			-- toggle Play/Rec mode
			if song.recording then
				song.recording = false
			else
				song.recording = true
			end	
		end
	end

end -- love.gamepadaxis


end -- K.input


-- this scene's update for each frame
function K.update()

	-- make LED fade
	if ledAlpha[1] > 0 then
		ledAlpha[1] = ledAlpha[1] - 0.05
	end

	-- make trackVolumeMeters fade
	for i = 1,8 do
		if trackVolumeMeter[i] > 0 then
			trackVolumeMeter[i] = trackVolumeMeter[i] - 1
		end
	end

	-- do when tick changes
	if tickChange ~= clock.tick then
		tickChange = clock.tick -- reset for next change to be detected
		ledAlpha[1] = 1 -- pulse 1st LED
	end

	-- do when tock changes
	if tockChange ~= clock.tock then
		tockChange = clock.tock -- reset for next change to be detected
		for i = 1,8 do
			if seq.loop[currentLoop].track[i].tick[clock.tick].tock[clock.tock] ~= "-" then
		      love.audio.stop(sfx[i])
		      love.audio.play(sfx[i])
		      trackVolumeMeter[i] = 50
			end
		end
	end

end -- K.update


-- this scene's screen draws go here
function K.draw()
	love.graphics.setFont(gameFont)
    if gamepad:isGamepadDown("back") then -- using joystick to detect SELECT button pressed
    	helpText = help[sceneNumber]
    	if not game.screenHD then
			love.graphics.draw(helpTextOverlay, 0, 0) -- draw this scene's helpTextOverlay
		else
			love.graphics.draw(HDhelpTextOverlay, 0, 0) -- draw this scene's helpTextOverlay
		end
	    love.graphics.printf(helpText, gameFont, 50, 80, 540, "left") -- display help text
	else
		helpText = ""

		-- display tempo
		if not game.screenHD then
			-- 640x480
		    love.graphics.setFont(bigFont)
			love.graphics.printf(song.tempo, bigFont, 196, 380, 100, "center") -- show tempo
		else
			-- 1280x720
		    love.graphics.setFont(bigFont)
			love.graphics.printf(song.tempo, bigFont, 334*2 + 68, (280*2) - 40, 100, "center") -- show tempo
		end

		if not game.screenHD then
			-- pulse red LED based on tempo -- 640x480
			love.graphics.setColor(1, 1, 1, ledAlpha[1]) -- test alpha
			love.graphics.draw(redLed, 75, 380)
			love.graphics.setColor(1, 1, 1, 1) -- reset alpha
		else
			-- pulse red LED based on tempo -- 1280x720
			love.graphics.setColor(1, 1, 1, ledAlpha[1]) -- test alpha
			love.graphics.draw(redLed, 334*2 + 150, (280*2) - 35)
			love.graphics.setColor(1, 1, 1, 1) -- reset alpha
		end

		-- display seq data
		-- seq in graphics bar display
		for j = 1,8 do -- loop for 8 samples
		tick = 1
		tock = 1
		for i = 1,16 do
			if (seq.loop[currentLoop].track[j].tick[tick].tock[tock]) ~= "-" then
				if not game.screenHD then
					-- 640x480
					love.graphics.draw(orangeBar, 16 + ((i-1)*38), 72 + ((j-1)*10))
				else
					-- 1280x720
					love.graphics.draw(HDorangeBar, 16*2 + ((i-1)*76), 72*2 + ((j-1)*20))
				end
			end
			tock = tock + 1
			if tock == 5 then
				tick = tick + 1
				tock = 1
			end		
		end -- i
		end	-- j
		
		if not game.screenHD then
		-- draw dividing lines for bars -- 640x480
		love.graphics.line(16+(38*4) , 72 , 16+(38*4),72+80)
		love.graphics.line(16+(38*8) , 72 , 16+(38*8),72+80)
		love.graphics.line(16+(38*12), 72 , 16+(38*12),72+80)
		else
		-- draw dividing lines for bars -- 1280x720
		love.graphics.line((16+(38*4))*2 , 72*2 , (16+(38*4))*2,(72+80)*2)
		love.graphics.line((16+(38*8))*2 , 72*2 , (16+(38*8))*2,(72+80)*2)
		love.graphics.line((16+(38*12))*2, 72*2 , (16+(38*12))*2,(72+80)*2)
		end

		if not game.screenHD then
			-- draw leds for current loop -- 640x480
			-- draw the grey LEDs first
			for i = 1,4 do
				love.graphics.draw(greyLED, 138 + ((i-1)*152), 45)	
			end
			-- draw the currentLoop's green LED
			love.graphics.draw(greenLED, 138 + ((currentLoop-1)*152), 45)	
		else
			-- draw leds for current loop -- 1280x720
			-- draw the grey LEDs first
			for i = 1,4 do
				love.graphics.draw(HDgreyLED, 138*2 + ((i-1)*152*2), 45*2)	
			end
			-- draw the currentLoop's green LED
			love.graphics.draw(HDgreenLED, 138*2 + ((currentLoop-1)*152*2), 45*2)	
		end

		-- seq in text display
		-- set font according to display
		if game.screenHD then
			love.graphics.setFont(HDmonoFont)
		else
			love.graphics.setFont(monoFont)
		end
		
		local loopCount = 0

		if not game.screenHD then
		-- draw seq data on 640x480
		for i = 1,4 do
		for j = 1,4 do
			love.graphics.print(seq.loop[currentLoop].track[1].tick[i].tock[j], 334 + (loopCount*8),170) -- draw beat highlight according to tick.tock
			love.graphics.print(seq.loop[currentLoop].track[2].tick[i].tock[j], 334 + (loopCount*8),180) -- draw beat highlight according to tick.tock
			love.graphics.print(seq.loop[currentLoop].track[3].tick[i].tock[j], 334 + (loopCount*8),190) -- draw beat highlight according to tick.tock
			love.graphics.print(seq.loop[currentLoop].track[4].tick[i].tock[j], 334 + (loopCount*8),200) -- draw beat highlight according to tick.tock
			love.graphics.print(seq.loop[currentLoop].track[5].tick[i].tock[j], 334 + (loopCount*8),210) -- draw beat highlight according to tick.tock
			love.graphics.print(seq.loop[currentLoop].track[6].tick[i].tock[j], 334 + (loopCount*8),220) -- draw beat highlight according to tick.tock
			love.graphics.print(seq.loop[currentLoop].track[7].tick[i].tock[j], 334 + (loopCount*8),230) -- draw beat highlight according to tick.tock
			love.graphics.print(seq.loop[currentLoop].track[8].tick[i].tock[j], 334 + (loopCount*8),240) -- draw beat highlight according to tick.tock
			loopCount = loopCount + 1
		end -- j
		end	-- i
		else
		-- draw seq data on 1280x720
		for i = 1,4 do
		for j = 1,4 do
			love.graphics.print(seq.loop[currentLoop].track[1].tick[i].tock[j], 334*2 + (loopCount*16),170*2) -- draw beat highlight according to tick.tock
			love.graphics.print(seq.loop[currentLoop].track[2].tick[i].tock[j], 334*2 + (loopCount*16),180*2) -- draw beat highlight according to tick.tock
			love.graphics.print(seq.loop[currentLoop].track[3].tick[i].tock[j], 334*2 + (loopCount*16),190*2) -- draw beat highlight according to tick.tock
			love.graphics.print(seq.loop[currentLoop].track[4].tick[i].tock[j], 334*2 + (loopCount*16),200*2) -- draw beat highlight according to tick.tock
			love.graphics.print(seq.loop[currentLoop].track[5].tick[i].tock[j], 334*2 + (loopCount*16),210*2) -- draw beat highlight according to tick.tock
			love.graphics.print(seq.loop[currentLoop].track[6].tick[i].tock[j], 334*2 + (loopCount*16),220*2) -- draw beat highlight according to tick.tock
			love.graphics.print(seq.loop[currentLoop].track[7].tick[i].tock[j], 334*2 + (loopCount*16),230*2) -- draw beat highlight according to tick.tock
			love.graphics.print(seq.loop[currentLoop].track[8].tick[i].tock[j], 334*2 + (loopCount*16),240*2) -- draw beat highlight according to tick.tock
			loopCount = loopCount + 1
		end -- j
		end	-- i
		end -- game.screenHD check

		-- display halfTime toggle
--		love.graphics.print("1/2 Time: " .. tostring(song.halfTime), 334, 250)
		if not game.screenHD then
			-- display for 640x480
			if song.halfTime then
				love.graphics.draw(indicatorHalfTime, 210, 340)
			end
		else
			-- display for 1280x720
			if song.halfTime then
				love.graphics.draw(indicatorHalfTime, (334*2) + 80, 280*2)
			end
		end

		if not game.screenHD then
			-- display Play / Rec toggle -- 640x480
			if song.recording then
				love.graphics.draw(indicatorRec, 360, 340)
			else
				love.graphics.draw(indicatorPlay, 360, 340)
			end
		else
			-- display Play / Rec toggle -- 1280x720
			if song.recording then
				love.graphics.draw(indicatorRec, 334*2, 280*2)
			else
				love.graphics.draw(indicatorPlay, 334*2, 280*2)
			end
		end

		if not game.screenHD then
		-- draw samples loaded on 640x480
		love.graphics.print(string.sub(sample[1],1,22), 192, 173)
		love.graphics.print(string.sub(sample[2],1,22), 192, 190)
		love.graphics.print(string.sub(sample[3],1,22), 192, 207)
		love.graphics.print(string.sub(sample[4],1,22), 192, 224)
		love.graphics.print(string.sub(sample[5],1,22), 192, 241)
		love.graphics.print(string.sub(sample[6],1,22), 192, 258)
		love.graphics.print(string.sub(sample[7],1,22), 192, 275)
		love.graphics.print(string.sub(sample[8],1,22), 192, 292)
		else
		-- draw samples loaded on 1280x720
		love.graphics.print(string.sub(sample[1],1,22), 192*2, 173*2)
		love.graphics.print(string.sub(sample[2],1,22), 192*2, 190*2)
		love.graphics.print(string.sub(sample[3],1,22), 192*2, 207*2)
		love.graphics.print(string.sub(sample[4],1,22), 192*2, 224*2)
		love.graphics.print(string.sub(sample[5],1,22), 192*2, 241*2)
		love.graphics.print(string.sub(sample[6],1,22), 192*2, 258*2)
		love.graphics.print(string.sub(sample[7],1,22), 192*2, 275*2)
		love.graphics.print(string.sub(sample[8],1,22), 192*2, 292*2)
		end

		if not game.screenHD then
		-- draw track volume meters on 640x480
		love.graphics.line(430,300, 430,300-trackVolumeMeter[1])
		love.graphics.line(434,300, 434,300-trackVolumeMeter[2])
		love.graphics.line(438,300, 438,300-trackVolumeMeter[3])
		love.graphics.line(442,300, 442,300-trackVolumeMeter[4])
		love.graphics.line(446,300, 446,300-trackVolumeMeter[5])
		love.graphics.line(450,300, 450,300-trackVolumeMeter[6])
		love.graphics.line(454,300, 454,300-trackVolumeMeter[7])
		love.graphics.line(458,300, 458,300-trackVolumeMeter[8])
		else
		-- draw track volume meters on 1280x720
		love.graphics.line(430*2,300*2, 430*2,300*2-(trackVolumeMeter[1]*2))
		love.graphics.line(434*2,300*2, 434*2,300*2-(trackVolumeMeter[2]*2))
		love.graphics.line(438*2,300*2, 438*2,300*2-(trackVolumeMeter[3]*2))
		love.graphics.line(442*2,300*2, 442*2,300*2-(trackVolumeMeter[4]*2))
		love.graphics.line(446*2,300*2, 446*2,300*2-(trackVolumeMeter[5]*2))
		love.graphics.line(450*2,300*2, 450*2,300*2-(trackVolumeMeter[6]*2))
		love.graphics.line(454*2,300*2, 454*2,300*2-(trackVolumeMeter[7]*2))
		love.graphics.line(458*2,300*2, 458*2,300*2-(trackVolumeMeter[8]*2))
		end

	    -- sub-beat = ((clock.tick-1)*4) + clock.tock
	    -- sub-beat - 1 = (((clock.tick-1)*4) + clock.tock) - 1
	    -- spacing = ((((clock.tick-1)*4) + clock.tock) - 1 ) * 38
	    -- padding = (((((clock.tick-1)*4) + clock.tock) - 1 ) * 38 ) + 13
	    if not game.screenHD then
	    	-- 640x480
			love.graphics.draw(beatHighlight, (((((clock.tick-1)*4) + clock.tock) - 1 ) * 38 ) + 16, 72) -- draw beat highlight according to tick.tock
		else
			-- 1280x720
			love.graphics.draw(HDbeatHighlight, (((((clock.tick-1)*4) + clock.tock) - 1 ) * 76 ) + 32, 72*2) -- draw beat highlight according to tick.tock
		end

		if not game.screenHD then
			-- 640x480
			-- checking on ticks and tocks, to match tempo
			love.graphics.printf(clock.tick .. "." .. clock.tock, bigFont, 346, 380, 100, "center") -- show ticks
		else
			-- 1280x720
			-- checking on ticks and tocks, to match tempo
			love.graphics.printf(clock.tick .. "." .. clock.tock, bigFont, (334*2) - 10, (280*2) - 40, 100, "center") -- show ticks
		end

		-- debug printscreen
		-- display game.system
		if game.screenHD then
			-- 1280x720
--			love.graphics.setFont(HDmonoFont)
--			love.graphics.print("System: "..game.system, 334*2, 280*2) -- show game system
--			love.graphics.print("Used: "..math.floor(game.time + love.timer.getTime()), 334*2, 290*2) -- show game time
		else
			-- 640x480
			love.graphics.setFont(monoFont)
			love.graphics.print("System: "..game.system, 334, 280) -- show game system
			love.graphics.print("Used: "..math.floor(game.time + love.timer.getTime()), 334, 290) -- show game time
		end

		-- display game tooltip
		if not game.screenHD then
			love.graphics.printf(game.tooltip, smallFont, 0, 458, 640, "left")
		else
			love.graphics.printf(game.tooltip, HDsmallFont, 0, 720-28, 1280, "left")
		end

		-- display power
		game.power.state, game.power.percent, game.power.timeleft = love.system.getPowerInfo( )
		if not game.screenHD then
			love.graphics.printf(tostring(game.power.state) .. " " .. tostring(game.power.percent) .. "%", smallFont, 0, 458, 640, "right") -- show game power
		else
			love.graphics.printf(tostring(game.power.state) .. " " .. tostring(game.power.percent) .. "%", HDsmallFont, 0, 720-28, 1280, "right") -- show game power
		end		
	end

end -- function K.draw()

return K
