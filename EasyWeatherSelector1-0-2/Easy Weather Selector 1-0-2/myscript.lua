-- Allows the plug-in to save information as long as the values start with "store."
local store = Util.optStorage(TheoTown.getStorage(), script:getDraft():getId())


-- Initializes the variables
local weatherType, fog


-- Sets the default global settings
store.weatherOpenPanel = store.weatherOpenPanel or false
-- Why am I using an if statement instead of the cleaner way? Because this is the only way I can get this stupid variable to save properly
if store.weatherButton == nil then
  store.weatherButton = true
end


-- Adds options to the settings.
function script:settings()
  return {
	{
      name = 'Toggle Weather Button',
      value = store.weatherButton,
      onChange = function(newState) store.weatherButton = newState end
    },
	{
      name = 'Open Weather Panel',
      value = store.weatherOpenPanel,
      onChange = function(newState) store.weatherOpenPanel = true Debug.toast('Close the settings to access the panel')end
    }
  }
end

-- Creates the weather panel
local function showObjectsDialog()
  dialog = GUI.createDialog{
  icon = Icon.WEATHER_SUNNY,
  title = 'Weather Panel',
  height = 90,
  width = 250
  }
  local layout = dialog.content:addLayout{
    vertical = true
  }
  local function addLine(label, height)
    local line = layout:addLayout{height = height}
    line:addLabel{text = label, w = 60}
    return line:addLayout{ x = 62 }
  end
  
  local line = addLine('Weather:', 26)
  local widthPerButton = (line:getClientWidth() - 3) / 3
  local function addSelectionButton(icon, state)
    line:addButton{
      width = widthPerButton,
	  text = '',
      icon = icon,
      onClick = function(self)
	    City.setFunVar ('weatherTime', state)
		City.setFunVar ('weatherLocked', 1)
	  end,
      isPressed = function() return City.getFunVar('weatherTime') == state end
    }
  end
  addSelectionButton(Icon.WEATHER_SUNNY, 290373)
  addSelectionButton(Icon.WEATHER_RAINY, 849711)
  addSelectionButton(Icon.WEATHER_LIGHTING, 622697)
  
  local line = addLine('Mode:', 26)
  line:addButton{
    icon = Icon.WEATHER_FOG,
    text = "",
    frameDefault = NinePatch.BUTTON,
    framePressed = NinePatch.BUTTON_DOWN,
    width = line:getClientWidth() / 2 - 1,
    onClick = function(self)
	  if City.getFunVar ('weatherFog') == 0 then
	    City.setFunVar ('weatherFog', 1)
	  else
	    City.setFunVar ('weatherFog', 0)
	  end
	end,
	isPressed = function() return City.getFunVar ('weatherFog') == 1 end
  }
  line:addButton{
    icon = Icon.LOCKED,
    text = "Locked",
    frameDefault = NinePatch.BUTTON,
    framePressed = NinePatch.BUTTON_DOWN,
    width = line:getClientWidth() / 2 - 1,
    onClick = function(self)
	  if City.getFunVar ('weatherLocked') == 0 then
	    City.setFunVar ('weatherLocked', 1)
	  else
	    City.setFunVar ('weatherLocked', 0)
	  end
	end,
	isPressed = function() return City.getFunVar ('weatherLocked') == 1 end
	}
end


-- Creates a button that players can use to open the panel
function script:buildCityGUI()
  if store.weatherButton == true then
    local sidebar = GUI.get('sidebarLine')
    local size = sidebar:getFirstPart():getChild(2):getWidth()
    weatherPanel = sidebar:getFirstPart():addButton{
      width = size,
      height = size,
      icon = Icon.WEATHER_SUNNY,
      frameDefault = Icon.NP_BLUE_BUTTON,
      frameDown = Icon.NP_BLUE_BUTTON_PRESSED,
      onClick = function()
	    showObjectsDialog()
	  end
    }
  end
end


function script:update()
  -- Hides the button when Hide UI mode is active
  if store.weatherButton == true then
    weatherPanel:setVisible(not TheoTown.SETTINGS.hideUI)
  end
  
  -- Used to open the weather panel
  if store.weatherOpenPanel == true then
    store.weatherOpenPanel = false
	showObjectsDialog()
  end
end