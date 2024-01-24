-- Allows the plug-in to save information as long as the values start with "newsSave."
local newsSave = Util.optStorage(TheoTown.getStorage(), script:getDraft():getId())


-- These variables save the plug-in's settings
if newsSave.newsToggleNewsTicker == nil then
	newsSave.newsToggleNewsTicker = newsSave.newsToggleNewsTicker or true
end
newsSave.newsPauseScrolling = newsSave.newsPauseScrolling or false
newsSave.newsPausedMessage = newsSave.newsPausedMessage or false
newsSave.newsDisasterHeadlines = newsSave.newsDisasterHeadlines or false
newsSave.newsScrollSpeed = newsSave.newsScrollSpeed or 3
newsSave.newsSpacerSize = newsSave.newsSpacerSize or 10
newsSave.newsPosition = newsSave.newsPosition or 0
newsSave.newsReset = false


-- Some local variables that are used throughout the code
local screenWidth, screenHeight
local headlineSpacer = ""
local onScreenText
local firstCharWidth
local headlinePosition
local newHeadline, lastHeadline
local headlineType
local headlineYCoord


-- Creates a blank space that will be placed between the headlines
for i = 1, newsSave.newsSpacerSize do 
	headlineSpacer = headlineSpacer .. " "
end
-- Gets the on-screen width of the spacer for later
local spacerWidth = Drawing.getTextSize (headlineSpacer, Font.SMALL)


function script:lateInit ()
	-- Checks if any headline packs have been enabled and removes the error text if true
	if headlines [-1] ~= "Error: No headline packs enabled" then
		for i = 1, 6, 1 do
			headlines:removeAt (1)
		end
	end
end


function script:settings()
	return {
		{
			name = 'Toggle News Ticker',
			value = newsSave.newsToggleNewsTicker,
			onChange = function(newState) newsSave.newsToggleNewsTicker = newState end
		},
		{
			name = 'Stop Scrolling When Paused',
			value = newsSave.newsPauseScrolling,
			onChange = function(newState) newsSave.newsPauseScrolling = newState end
		},
		{
			name = 'Game Paused Message',
			value = newsSave.newsPausedMessage,
			onChange = function(newState) newsSave.newsPausedMessage = newState end
		},
		{
			name = 'Disaster Headlines',
			value = newsSave.newsDisasterHeadlines,
			onChange = function(newState) newsSave.newsDisasterHeadlines = newState end
		},
		{
			name = 'Scroll Speed',
			value = newsSave.newsScrollSpeed,
			values = {5, 3, 1},
			valueNames = {'Slow', 'Normal', 'Fast'},
			onChange = function(newState)
				newsSave.newsScrollSpeed = newState
				if City then
					headlinePosition = (screenWidth-100)*newsSave.newsScrollSpeed
				end
			end
		},
		{
			name = 'Spacer Size',
			value = newsSave.newsSpacerSize,
			values = {5, 10, 20},
			valueNames = {'Small', 'Normal', 'Large'},
			onChange = function(newState)
				newsSave.newsSpacerSize = newState
				Debug.toast ('Restart to see effect')
			end
		},
		{
			name = 'Position',
			value = newsSave.newsPosition,
			values = {0, 1},
			valueNames = {'Top', 'Bottom'},
			onChange = function(newState) newsSave.newsPosition = newState end
		},
		{
			name = 'Reset TNN Settings',
			value = newsSave.newsReset,
			onChange = function(newState)
				newsSave.newsToggleNewsTicker = true
				newsSave.newsPauseScrolling = false
				newsSave.newsPausedMessage = false
				newsSave.newsDisasterHeadlines = false
				newsSave.newsScrollSpeed = 3
				newsSave.newsSpacerSize = 10
				newsSave.newsPosition = 0
				newsSave.newsReset = false
				Debug.toast ('Theo News Network reset!')
			end
		}
	}
end


function script:enterCity ()
	screenWidth, screenHeight = Drawing.getSize()
	headlinePosition = (screenWidth-100)*newsSave.newsScrollSpeed
	onScreenText = "Welcome Back Mayor!" .. headlineSpacer
	firstCharWidth = Drawing.getTextSize ("W", Font.SMALL)
	lastHeadline = "Welcome Back Mayor!"
end


function script:leaveCity ()
	-- Resets these variables
	headlinePosition = nil
	onScreenText = nil
	firstCharWidth = nil
	newHeadline = nil
	lastHeadline = nil
end


function script:update ()
	if newsSave.newsToggleNewsTicker == true then
		-- Gets the width and height of the screen
		screenWidth, screenHeight = Drawing.getSize()
		
		-- Sets the vertical position of the news ticker
		if newsSave.newsPosition == 0 then
			headlineYCoord = 0
		else
			headlineYCoord = screenHeight-21
		end
		
		-- Sends the news ticker's text to the left. Jitters a bit when the FPS drops
		if newsSave.newsPauseScrolling == false or City.getSpeed () ~= 0 then
			headlinePosition = headlinePosition-1
		end
		
		-- Removes off-screen characters from the news ticker
		if headlinePosition <= (-150-firstCharWidth)*newsSave.newsScrollSpeed then
			headlinePosition = -150*newsSave.newsScrollSpeed
			onScreenText = string.sub(onScreenText, 2)
			firstCharWidth = Drawing.getTextSize (onScreenText:sub (1, 1), Font.SMALL)
		end
		
		-- Adds more text to the news ticker if it is smaller than the screen width plus the margins
		while Drawing.getTextSize (onScreenText, Font.SMALL) < screenWidth+300+firstCharWidth do
			-- This decides what headline to use. It's probably inefficient, but I'll have to change this in the future anyway
			if City.getSpeed () == 0 and newsSave.newsPausedMessage == true then -- Game Paused message
				newHeadline = "Game Paused"
			elseif City.getDisaster () ~= nil and newsSave.newsDisasterHeadlines == true then -- Disaster headline
				newHeadline = disasterHeadlines:pick ()
				if newHeadline == lastHeadline then -- Ensures this headline is different from the last
					newHeadline = disasterHeadlines [disasterHeadlines:find (lastHeadline)-1] or disasterHeadlines [disasterHeadlines:find (lastHeadline)-2]
				end
			else -- Generic headline
				newHeadline = headlines:pick ()
				if newHeadline == lastHeadline then -- Ensures this headline is different from the last
					newHeadline = headlines [headlines:find (lastHeadline)-1] or headlines [headlines:find (lastHeadline)-2]
				end
			end
			-- Assigns the new headline to the news ticker
			onScreenText = onScreenText .. newHeadline .. headlineSpacer
			lastHeadline = newHeadline
		end
		
		-- Checks if Hide UI mode is being used
		if not TheoTown.SETTINGS.hideUI then
			-- Draws the background
			Drawing.drawNinePatch (NinePatch.BUTTON_DOWN, -150, 0+headlineYCoord, screenWidth+150, 20)
			Drawing.drawNinePatch (NinePatch.PANEL, -150, 3+headlineYCoord, screenWidth+150, 15)
			
			-- Draws the text
			Drawing.setColor (0, 0, 0)
			Drawing.drawText (onScreenText, headlinePosition/newsSave.newsScrollSpeed, 5+headlineYCoord, Font.SMALL)
		end
	end
end


--[[ (Debug stuff for testing)
			Drawing.drawText (onScreenText, headlinePosition/newsSave.newsScrollSpeed+250, 50, Font.SMALL)
			Drawing.drawText (onScreenText, 100, 100, Font.SMALL)
			Drawing.drawText (onScreenText, -500, 125, Font.SMALL)
			Drawing.drawText (firstCharWidth .. " - " .. screenWidth .. " - " .. headlinePosition/newsSave.newsScrollSpeed, 100, 150, Font.SMALL)
			Drawing.drawText (headlinePosition, 100, 175, Font.SMALL)
			Drawing.drawText (City.getDisaster () or "nil", 100, 200, Font.SMALL)
]]--