-- scene-0
-- scene name : Boot Screen
-- scene functions are :
-- .input() for all the key mapping
-- .draw() for the draw state

local sceneNumber = 0
local autosavedScene = 0

-- graphical overlay for this scene's help
local helpTextOverlay = love.graphics.newImage("bgart/bootscreen.png")

-- Scene's entry SFX
local sceneStartSFX = love.audio.newSource("sfx/SMBootSound.ogg", "static")

-- Reset All Data warning
local resetAllData = love.graphics.newImage("pic/reset-all-data.png")
local HDresetAllData = love.graphics.newImage("pic/HD-reset-all-data.png")


local resetChargeTime = 0 -- counter to detect 3 seconds hold
local resetDone = false -- state of reset

local K = {} -- for return functions to main.lua

local helpText = ""


-- K.init is for loading assets for the scene (done only once at game load)
function K.init()
	-- background to display
	if game.screenHD then
		bgart[sceneNumber] = love.graphics.newImage("bgart/HD-bootscreen.png") -- 1280x720
	else
		bgart[sceneNumber] = love.graphics.newImage("bgart/bootscreen.png") -- 640x480
	end
	-- help text to appear
	help[sceneNumber] = ""
	game.tooltip = ""
	
	-- load autosaved scene (last scene before quit)
	local f = io.input (love.filesystem.getSaveDirectory().."//autosaves/currentscene.txt")
	autosavedScene = tonumber(f:read())
	game.tooltip = ""
	f:close()
end


-- K.start is to init anything when scene starts, can be reloaded multiple times
function K.start()
	love.audio.play(sceneStartSFX)
end


-- K.input is for keymapping
function K.input()

function love.gamepadreleased(joystick, button)

	-- detecting Face Buttons, Top (Y), Left (X), Bottom (A), Right (B)
	if button == "y" then
      -- Top Button released
		scene[autosavedScene].input() -- change input key-map to autosaved scene
    	scene[autosavedScene].start() -- kickstart the scene
    	scene.current = autosavedScene -- change to autosaved scene
		scene.previous = sceneNumber -- put current scene into scene history
	end
	if button == "x" then
      -- Left Button released
		scene[autosavedScene].input() -- change input key-map to autosaved scene
    	scene[autosavedScene].start() -- kickstart the scene
    	scene.current = autosavedScene -- change to autosaved scene
		scene.previous = sceneNumber -- put current scene into scene history
	end
	if button == "a" then
      -- Bottom Button released
		scene[autosavedScene].input() -- change input key-map to autosaved scene
    	scene[autosavedScene].start() -- kickstart the scene
    	scene.current = autosavedScene -- change to autosaved scene
		scene.previous = sceneNumber -- put current scene into scene history
	end
	if button == "b" then
      -- Right Button released
		scene[autosavedScene].input() -- change input key-map to autosaved scene
    	scene[autosavedScene].start() -- kickstart the scene
    	scene.current = autosavedScene -- change to autosaved scene
		scene.previous = sceneNumber -- put current scene into scene history
	end

end -- love.gampadreleased

end -- K.input

-- this scene's update for each frame
function K.update()

	-- detecting L1 + R1 for Clear All Data
	if gamepad:isGamepadDown("leftshoulder") and gamepad:isGamepadDown("rightshoulder") and resetDone == false then
		resetChargeTime = resetChargeTime + 2.7 -- adjust to change required charge time
		game.tooltip = "L1+R1 pressed: Hold 3 secs to reset all data ... "..resetChargeTime

		if resetChargeTime > 500 then
			game.tooltip = "Reset all data - activated. Default files written."
			restoreDefaults()

			-- reload autosaved scene (last scene before quit)
			local f = io.input (love.filesystem.getSaveDirectory().."//autosaves/currentscene.txt")
			autosavedScene = tonumber(f:read())
			f:close()
			
			resetDone = true
		end
	else
		resetChargeTime = 0
	end


	-- detecting end of audio logo playback
	if not sceneStartSFX:isPlaying( ) then
		scene[autosavedScene].input() -- change input key-map to autosaved scene
    	scene[autosavedScene].start() -- kickstart the scene
    	scene.current = autosavedScene -- change to autosaved scene
		scene.previous = sceneNumber -- put current scene into scene history
	end

end -- K.update


-- this scene's screen draws go here
function K.draw()

	if not game.screenHD then -- show on small screens
		-- display Reset All Data warning if resetChargeTime is charging
		if resetChargeTime > 0 and resetDone == false then
			love.graphics.draw(resetAllData, 70, 354)
			love.graphics.line(72, 396, 72+resetChargeTime, 396)
		end
	
		-- display game tooltip
		love.graphics.printf(game.tooltip, smallFont, 0, 458, 640, "left")

		-- display power
		game.power.state, game.power.percent, game.power.timeleft = love.system.getPowerInfo( )
		love.graphics.printf(tostring(game.power.state) .. " " .. tostring(game.power.percent) .. "%", smallFont, 0, 458, 640, "right") -- show game power
	else
		-- this is for 1280 x 720
		-- display Reset All Data warning if resetChargeTime is charging
		if resetChargeTime > 0 and resetDone == false then
			love.graphics.line(142, 616, 142+(resetChargeTime*2), 616)
			love.graphics.draw(HDresetAllData, 140, 620)
		end

		-- display game tooltip
		love.graphics.printf(game.tooltip, HDsmallFont, 0, 720-28, 1280, "left")

		-- display power
		game.power.state, game.power.percent, game.power.timeleft = love.system.getPowerInfo( )
		love.graphics.printf(tostring(game.power.state) .. " " .. tostring(game.power.percent) .. "%", HDsmallFont, 0, 720-28, 1280, "right") -- show game power
	end

end -- K.draw


return K
