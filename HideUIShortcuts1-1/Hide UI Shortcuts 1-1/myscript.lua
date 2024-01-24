-- Allows the plug-in to save information as long as the values start with "shortcutSave."
local shortcutSave = Util.optStorage(TheoTown.getStorage(), script:getDraft():getId())

-- Defines these as local variables so I can use them again later
local button, shortcut

-- Sets the default settings
if shortcutSave.shortcutToggle == nil then
  shortcutSave.shortcutToggle = true
end

function script:settings()
  return {
	{
      name = 'Toggle Shortcut Button',
      value = shortcutSave.shortcutToggle,
      onChange = function(newState) shortcutSave.shortcutToggle = newState end
    }
  }
end

function script:buildCityGUI()
  -- Adds the shortcut button if shortcutSave.shortcutToggle is true
  if shortcutSave.shortcutToggle == true then
	local sidebar = GUI.get('sidebarLine')
    local size = sidebar:getFirstPart():getChild(2):getWidth()
    button = sidebar:getFirstPart():addButton{
    width = size,
    height = size,
    icon = Icon.MINUS,
    frameDefault = Icon.NP_BLUE_BUTTON,
    frameDown = Icon.NP_BLUE_BUTTON_PRESSED,
    onClick = function()
	  TheoTown.SETTINGS.hideUI = true
    end
    }
  end
  -- Adds an off-screen button that is used to add the keyboard shortcut. I couldn't just disable its visibility because that would disable the shortcut.
  shortcut = GUI.getRoot():getFirstPart():addPanel{
  width = 0,
  height = 0,
  icon = nil,
  frameDefault = nil,
  frameDown = nil,
  onClick = function()
    if TheoTown.SETTINGS.hideUI == false then
      TheoTown.SETTINGS.hideUI = true
    else
	  TheoTown.SETTINGS.hideUI = false
    end
  end
    }
  -- Here is where the keyboard shortcut is defined. Feel free to change this to whatever you like.
  shortcut:addHotkey(Keys.SLASH)
  -- This part moves the button offscreen. For some reason, a button with size 0 is still visible, which is why I have done this.
  shortcut:setPosition(-50, -50)
end

-- Makes the sidebar button invisible when Hide UI mode is used
function script:update()
  button:setVisible(not TheoTown.SETTINGS.hideUI)
end