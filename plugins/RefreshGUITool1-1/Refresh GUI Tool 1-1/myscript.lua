-- Allows the plug-in to save information as long as the values start with "save."
local save = Util.optStorage(TheoTown.getStorage(), script:getDraft():getId())

-- Sets the defualt for this setting.
if save.toggleRefresher == nil then
  save.toggleRefresher = true
end

-- Adds an option to the settings.
function script:settings()
  return {
    {
      name = 'Toggle Refresh Tool',
      value = save.toggleRefresher,
      onChange = function(newState) save.toggleRefresher = newState end
    }
  }
end

--Adds the button to the sidebar
function script:buildCityGUI()
  if save.toggleRefresher == true then
	local sidebar = GUI.get('sidebarLine')
    local size = sidebar:getFirstPart():getChild(2):getWidth()
    button = sidebar:getFirstPart():addButton{
    width = size,
    height = size,
    icon = Icon.TURN_LEFT,
    frameDefault = Icon.NP_BLUE_BUTTON,
    frameDown = Icon.NP_BLUE_BUTTON_PRESSED,
    onClick = function()
	  City.rebuildUI()
    end
    }
  end
end

--Hides the button when Hide UI mode is used
function script:update()
if save.toggleRefresher == true then
  button:setVisible(not TheoTown.SETTINGS.hideUI)
end
end