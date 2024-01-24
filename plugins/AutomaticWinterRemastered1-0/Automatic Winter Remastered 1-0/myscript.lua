-- Allows the plug-in to save information as long as the values start with "winStore."
local winStore = Util.optStorage(TheoTown.getStorage(), script:getDraft():getId())


-- Sets the default global settings
winStore.winOpenPanel = false


-- Sets winter mode to off on startup
TheoTown.SETTINGS.winter = 0


-- Initializes the variables
local month, framesCount


-- Creates a function that changes the season based on the month and winter mode
function changeSeason (mode, invert, month)
  -- Creates a function for changing winter. The output will be inverted if the 2nd option is true.
  function invertSeasonCheck (mode, invert)
    if invert == false then
      return City.setFunVar ('winter', mode)
    end
    if invert == true and mode == 1 then
      return City.setFunVar ('winter', 2)
    end
    if invert == true and mode == 2 then
      return City.setFunVar ('winter', 1)
    end
  end
  
  if mode <= 2 then
    City.setFunVar ('winter', mode)
  elseif mode == 3 then
    if month <= 1 or month >= 11 then
	   invertSeasonCheck (1, invert)
	else
	  invertSeasonCheck (2, invert)
	end 
  elseif mode == 4 then
    if month <= 3 or month >= 10 then
	   invertSeasonCheck (1, invert)
	else
	  invertSeasonCheck (2, invert)
	end 
  elseif mode == 5 then
    if month <= 5 or month >= 9 then
	   invertSeasonCheck (1, invert)
	else
	  invertSeasonCheck (2, invert)
	end 
  end
end


-- Adds options to the settings.
function script:settings()
  return {
	{
      name = 'Open Winter Panel',
      value = winStore.winOpenPanel,
      onChange = function(newState) winStore.winOpenPanel = true Debug.toast('Close the settings to access the panel')end
    }
  }
end


-- Creates the customization panel
local function showObjectsDialog()
  dialog = GUI.createDialog{
  icon = Icon.WINTER,
  title = 'Auto Winter Customization',
  height = 165,
  width = 345,
  onClose = function()
    Debug.toast('Saved!')
	-- Checks the month and changes to winter mode accordingly
	changeSeason (winCityStore.winMode, winCityStore.winInvert, month)
  end
  }
  local layout = dialog.content:addLayout{
    vertical = true
  }
  local function addLine(label, height)
    local line = layout:addLayout{height = height}
    line:addLabel{text = label, w = 40}
    return line:addLayout{ x = 62 }
  end

  local line = addLine('Mode:', 26)
  local widthPerButton = (line:getClientWidth() - 5) / 3
  local function addSelectionButton(text, state)
    line:addButton{
      width = widthPerButton,
	  text = text,
      onClick = function()
	    winCityStore.winMode = state
		winCityStore.winInvert = false
	  end,
      isPressed = function() return winCityStore.winMode == state end
    }
  end
  addSelectionButton('Real-Time', 0)
  addSelectionButton('Always On', 1)
  addSelectionButton('Always Off', 2)
  
  -- What a lazy way to add another row of buttons. Too bad I won't be fixing it...
  local line = addLine('', 26)
  local function addSelectionButton2(text, state)
    line:addButton{
      width = widthPerButton,
	  text = text,
      onClick = function() winCityStore.winMode = state end,
      isPressed = function() return winCityStore.winMode == state end
    }
  end
  addSelectionButton2('3 Months', 3)
  addSelectionButton2('6 Months', 4)
  addSelectionButton2('9 Months', 5)

  local line = addLine('Invert:', 26)
  line:addButton{
    icon = Icon.OK,
    text = "Yes",
    frameDefault = NinePatch.BUTTON,
    framePressed = NinePatch.BUTTON_DOWN,
    width = line:getClientWidth() / 2 - 1,
    onClick = function()
	  winCityStore.winInvert = true
	  if winCityStore.winMode <= 2 then
	    winCityStore.winInvert = false
		Debug.toast ('Use the 3, 6, or 9 month options to invert the season.')
	  end
	end,
	isPressed = function() return winCityStore.winInvert == true end
  }
  line:addButton{
    icon = Icon.CANCEL,
    text = "No",
    frameDefault = NinePatch.BUTTON,
    framePressed = NinePatch.BUTTON_DOWN,
    width = line:getClientWidth() / 2 - 1,
    onClick = function()
	  winCityStore.winInvert = false
	end,
	isPressed = function() return winCityStore.winInvert == false end
  }
  local line = addLine('Note:', 50)
  line:addTextFrame{
    text = 'Do not use the winter settings in the gameplay tab with this plug-in installed. To change the winter mode, use this menu only!'
  }
end


function script:enterCity()
  -- Allows the city to save its temperature settings
  winCityStore = Util.optStorage(City.getStorage(), script:getDraft():getId())
  
  -- Sets the default city settings
  winCityStore.winMode = winCityStore.winMode or 2
  winCityStore.winInvert = winCityStore.winInvert or false
  
  -- Starts the frames count
  framesCount = 0
  
  -- Gets the month
  month = City.getMonth()
  
  -- Checks the month and changes to winter mode accordingly
  changeSeason (winCityStore.winMode, winCityStore.winInvert, month)
end


function script:nextMonth()
  -- Sets the month after every new month
  month = City.getMonth()
  
  -- Checks the month and changes to winter mode accordingly
  changeSeason (winCityStore.winMode, winCityStore.winInvert, month)
end


function script:leaveCity ()
  -- Resets the player's winter mode setting after they leave the city
  City.setFunVar ('winter', 0)
end


function script:update()
  -- Shows the player the customization panel
  if winStore.winOpenPanel == true then
    if framesCount == 5 then
      showObjectsDialog()
	  winStore.winOpenPanel = false
    else
      framesCount = framesCount+1
    end
  end
end