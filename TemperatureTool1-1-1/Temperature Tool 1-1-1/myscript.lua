-- Sets a seed for the RNG
math.randomseed(os.time())

-- Creates a variables that allows the plug-in to be detected by other plug-ins
TemperatureToolCheck = true
globalTemp = 0

-- Creates a custom function that converts Fahrenheit to Celsius and rounds the outcome. If the input is Fahrenheight, the function will simply return the inputted temperature. I made this because I am lazy.
function convertTemp (tempInput, tempUnitInput)
  if tempUnitInput == 'F' then
    return tempInput
  else
    return math.floor(((tempInput-32)*5/9)+0.5)
  end
end


-- Allows the plug-in to save information as long as the values start with "store."
local store = Util.optStorage(TheoTown.getStorage(), script:getDraft():getId())


-- Sets the default global settings
store.tempToggleTool = store.tempToggleTool or true
store.tempShowBackground = store.tempShowBackground or false
store.tempSlowMode = store.tempSlowMode or 0
store.tempToolPosition = store.tempToolPosition or 4
store.tempUnit = store.tempUnit or 'F'
store.tempOpenPanel = store.tempOpenPanel or false

-- Initializes the variables.
local temp, winterOffset, width, height, x, y, nightOffset, moonOffset, slowCount, framesCount, tempOffsetPlaceholder, tempPlaceholder


-- Initializes the month variable with a placeholder value. Hopefully, this should fix a bug that crashed the game.
local month = 1

-- Adds options to the settings.
function script:settings()
  return {
    {
      name = 'Toggle Temperature Tool',
      value = store.tempToggleTool,
      onChange = function(newState) store.tempToggleTool = newState end
    },
	{
      name = 'Show Background',
      value = store.tempShowBackground,
      onChange = function(newState) store.tempShowBackground = newState end
    },
	{
      name = 'Slow Mode',
      value = store.tempSlowMode,
      values = {0, 3, 5, 10},
      valueNames = {'Off', '3 Days', '5 Days', '10 Days'},
      onChange = function(newState) store.tempSlowMode = newState end
    },
	{
      name = 'Position',
      value = store.tempToolPosition,
      values = {1, 2, 3, 4},
      onChange = function(newState) store.tempToolPosition = newState end
    },
	{
      name = 'Unit',
      value = store.tempUnit,
      values = {'F', 'C'},
      onChange = function(newState) store.tempUnit = newState end
    },
	{
      name = 'Open Temperature Panel',
      value = store.tempOpenPanel,
      onChange = function(newState) store.tempOpenPanel = true Debug.toast('Close the settings to access the panel')end
    }
  }
end


-- Creates the customization panel
local function showObjectsDialog()
  dialog = GUI.createDialog{
  icon = Icon.WEATHER_SUNNY,
  title = 'Temperature Customization',
  height = 90,
  onClose = function()
    Debug.toast('Saved!')
  end
  }
  local layout = dialog.content:addLayout{
    vertical = true
  }
  local function addLine(label, height)
    local line = layout:addLayout{height = height}
    line:addLabel{text = label, w = 60}
    return line:addLayout{ x = 62 }
  end

  local line = addLine('Hemisphere:', 26)
  line:addButton{
    icon = Icon.BACK_UPWARDS,
    text = "Northern",
    frameDefault = NinePatch.BUTTON,
    framePressed = NinePatch.BUTTON_DOWN,
    width = line:getClientWidth() / 2 - 1,
    onClick = function()
	  citystore.tempInvertSeason = false
	end,
	isPressed = function() return citystore.tempInvertSeason == false end
  }
  line:addButton{
    icon = Icon.RESET,
    text = "Southern",
    frameDefault = NinePatch.BUTTON,
    framePressed = NinePatch.BUTTON_DOWN,
    width = line:getClientWidth() / 2 - 1,
    onClick = function()
	  citystore.tempInvertSeason = true
	end,
	isPressed = function() return citystore.tempInvertSeason == true end
  }
  
  local line = addLine('Temp. Offset:', 26)
  local widthPerButton = (line:getClientWidth() - 5) / 5
  local function addSelectionButton(text, state)
    line:addButton{
      width = widthPerButton,
	  text = text,
      onClick = function() citystore.tempOffset = state end,
      isPressed = function() return citystore.tempOffset == state end
    }
  end
  addSelectionButton('Cold', -20)
  addSelectionButton('Cool', -10)
  addSelectionButton('Off', 0)
  addSelectionButton('Warm', 10)
  addSelectionButton('Hot', 20)
end


function script:enterCity()
  -- Allows the city to save its temperature settings
  citystore = Util.optStorage(City.getStorage(), script:getDraft():getId())
  
  -- Sets the default city settings
  citystore.tempOffset = citystore.tempOffset or 0
  citystore.tempPanelShown = citystore.tempPanelShown or false
  citystore.tempInvertSeason = citystore.tempInvertSeason or false
  
  -- Sets the month
  month = City.getMonth()
  
  -- Starts the slowCount
  slowCount = 0
  
  -- Starts the framesCount
  framesCount = 0
  
  -- Checks if the player is on the moon
  if DSA.isInMoon () == true then
	moonOffset = -280
  else
    moonOffset = 0
  end

  -- Sets the initial temperature for the tool
  -- Checks the time of day
	if TheoTown.daytime*24 >= 19 or TheoTown.daytime*24 <= 3 then
	  nightOffset = math.random(-10, -2)
	else
	  nightOffset = 0
	end
	
	-- Checks for winter mode
	if City.getFunVar('winter') == 1 then
	  winterOffset = math.random(-45, -38)
	else
	  winterOffset = 0
	end

	-- Sets the temperature based on the month
	if month <= 6 and citystore.tempInvertSeason == false then
      temp = month*12+math.random(-15, 15)
	elseif month > 6 and citystore.tempInvertSeason == false then
	  temp = (6-(month-7))*14+math.random(-15, 15)
	elseif month <= 6 and citystore.tempInvertSeason == true then
	  temp = (7-month)*14+math.random(-15, 15)
	elseif month > 6 and citystore.tempInvertSeason == true then
	  temp = (month-6)*12+math.random(-15, 15)
	end
	
	-- Saves some values to new variables so things don't break
	tempOffsetPlaceholder = citystore.tempOffset
	tempPlaceholder = temp
	
	-- Combines all the temperature factors
	temp = temp+citystore.tempOffset+nightOffset+winterOffset+moonOffset

	-- Saves the temp to a global variable for other plug-ins to use
	globalTemp = temp

	-- Converts the temperature to Celsius
	if store.tempUnit == 'C' then
	  temp = math.floor(((temp-32)*5/9)+0.5)
	  nightOffset = convertTemp (tempPlaceholder+nightOffset, store.tempUnit) - convertTemp (tempPlaceholder, store.tempUnit)
	  winterOffset = convertTemp (tempPlaceholder+winterOffset, store.tempUnit) - convertTemp (tempPlaceholder, store.tempUnit)
	  tempOffsetPlaceholder = convertTemp (tempPlaceholder+citystore.tempOffset, store.tempUnit) - convertTemp (tempPlaceholder, store.tempUnit)
	end
end


-- Sets the month after every new month
function script:nextMonth()
  month = City.getMonth()
end


function script:nextDay()
  -- Checks whether the tool is enabled
  if store.tempToggleTool == true and slowCount == store.tempSlowMode then
    
	-- Checks the time of day
	if TheoTown.daytime*24 >= 19 or TheoTown.daytime*24 <= 3 then
	  nightOffset = math.random(-10, -2)
	else
	  nightOffset = 0
	end
	
	-- Checks for winter mode
	if City.getFunVar('winter') == 1 then
	  winterOffset = math.random(-45, -38)
	else
	  winterOffset = 0
	end

	-- Sets the temperature based on the month
	if month <= 6 and citystore.tempInvertSeason == false then
      temp = month*12+math.random(-15, 15)
	elseif month > 6 and citystore.tempInvertSeason == false then
	  temp = (6-(month-7))*14+math.random(-15, 15)
	elseif month <= 6 and citystore.tempInvertSeason == true then
	  temp = (7-month)*14+math.random(-15, 15)
	elseif month > 6 and citystore.tempInvertSeason == true then
	  temp = (month-6)*12+math.random(-15, 15)
	end
	
	-- Saves some values to new variables so things don't break
	tempOffsetPlaceholder = citystore.tempOffset
	tempPlaceholder = temp
	
	-- Combines all the temperature factors
	temp = temp+citystore.tempOffset+nightOffset+winterOffset+moonOffset

	-- Saves the temp to a global variable for other plug-ins to use
	globalTemp = temp

	-- Converts the temperature to Celsius
	if store.tempUnit == 'C' then
	  temp = math.floor(((temp-32)*5/9)+0.5)
	  nightOffset = convertTemp (tempPlaceholder+nightOffset, store.tempUnit) - convertTemp (tempPlaceholder, store.tempUnit)
	  winterOffset = convertTemp (tempPlaceholder+winterOffset, store.tempUnit) - convertTemp (tempPlaceholder, store.tempUnit)
	  tempOffsetPlaceholder = convertTemp (tempPlaceholder+citystore.tempOffset, store.tempUnit) - convertTemp (tempPlaceholder, store.tempUnit)
	end
  end
  
  if store.tempSlowMode ~= 0 then
    if slowCount == store.tempSlowMode then
	  slowCount = 0
	end
	slowCount = slowCount+1
  else
    slowCount = 0
  end
end


function script:update()
  -- Shows the player the customization panel
  if framesCount == 5 then
    if store.tempOpenPanel == true or citystore.tempPanelShown == false then
      showObjectsDialog()
	  store.tempOpenPanel = false
	  citystore.tempPanelShown = true
    end
  else
    framesCount = framesCount+1
  end
  
  -- Checks whether the tool is enabled
  if store.tempToggleTool == true and not TheoTown.SETTINGS.hideUI then
    -- Gets the screen's resolution so everything is drawn in the correct locations
    width, height = Drawing.getSize()
	
	-- Offsets the tool's position based on store.tempToolPosition
	if store.tempToolPosition == 1 then
	  width = 0
	  x = 3
	elseif store.tempToolPosition == 2 then
	  width = 0
	  x = 32
	elseif store.tempToolPosition == 3 then
	  x = -79
	elseif store.tempToolPosition == 4 then
	  x = -49
	end

    -- Draws the background for the tool if store.tempShowBackground is true
    if store.tempShowBackground == true then
      Drawing.drawNinePatch (NinePatch.BLUE_BUTTON_PRESSED, width+x-2, height-76, 45, 17)
    end

    -- Draws the temperature text on the screen
    Drawing.setColor (0, 0, 0)
    Drawing.drawText (temp .. '°' .. store.tempUnit, width+x, height-72)
    Drawing.drawText (temp .. '°' .. store.tempUnit, width+x, height-73)
    Drawing.reset ()
    Drawing.drawText (temp .. '°' .. store.tempUnit, width+x, height-74)
  end
end

function script:earlyTap(tx,ty,sx,sy)
  if store.tempToggleTool == true then
    if sx >= width+x-2 and sx <= width+x-2+45 and sy >= height-76 and sy <= height-76+17 and not TheoTown.SETTINGS.hideUI then
      GUI.createDialog{
		icon = Icon.INFO,
		title = 'Temperature Factors',
		text = 'Base Temperature: ' .. temp-tempOffsetPlaceholder-nightOffset-winterOffset .. '°' .. store.tempUnit .. '\nNighttime: ' .. nightOffset .. '°' .. store.tempUnit .. '\nWinter Mode: ' .. winterOffset .. '°' .. store.tempUnit .. '\nTemperature Offset: ' .. tempOffsetPlaceholder .. '°' .. store.tempUnit .. '\n\nTotal: ' .. temp .. '°' .. store.tempUnit,
		width = 225,
		height = 160
      }
      return false
    end
  end
end