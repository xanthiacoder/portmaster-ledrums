-- scene-999
-- scene name : Exit Screen
-- scene functions are :
-- .init() for one-time initialization of stuff
-- .input() for all the key mapping
-- .start() to kickstart the scene
-- .update() for frame by frame activity
-- .draw() for the draw state


local K = {}

local helpText = ""


-- Scene's entry SFX
local sceneStartSFX = love.audio.newSource("music/LowEntropy-ExitLoop.ogg", "stream")

-- K.init is for loading assets for the scene
function K.init()
	bgart[999] = love.graphics.newImage("bgart/exitscreen.jpg")
	help[999] = ""
end




function K.input()


function love.gamepadpressed(joystick, button)

	-- detecting Face Buttons, Top (Y), Left (X), Bottom (A), Right (B)
	if button == "y" then
      -- Top Button pressed
		love.event.quit()
	end
	if button == "x" then
      -- Left Button pressed
		love.event.quit()
	end
	if button == "a" then
      -- Bottom Button pressed
		love.event.quit()
	end
	if button == "b" then
      -- Right Button pressed
		love.event.quit()
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



end -- function K.input


-- K.start is to init anything when scene starts, can be reloaded multiple times
function K.start()
	sceneStartSFX:setLooping(true)
	sceneStartSFX:play()
end


-- this scene's update for each frame
function K.update()

end


-- this scene's screen draws go here
function K.draw()
	love.graphics.setFont(gameFont)
	if isSelectDown then -- SELECT pressed
    	helpText = help[999]
	else
		helpText = ""
    end
    love.graphics.printf(helpText, gameFont, 50, 80, 540, "left")
end


return K