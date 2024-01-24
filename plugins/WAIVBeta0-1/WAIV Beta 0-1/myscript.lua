-- Allows the plug-in to save information as long as the values start with "store."
local store = Util.optStorage(TheoTown.getStorage(), script:getDraft():getId())

-- Sets the default settings
if store.toggleMenu == nil then
  store.toggleMenu = true
end
if store.toggleButton == nil then
  store.toggleButton = true
end
if store.showFrame == nil then
  store.showFrame = true
end
if store.performanceMode == nil then
  store.performanceMode = false
end
if store.showCrosshair == nil then
  store.showCrosshair = false
end
if store.easySelection == nil then
  store.easySelection = false
end
if store.ignoreRCI == nil then
  store.ignoreRCI = false
end

--Initializes the variables
local x, y, draft, name, buildingType, monthlyPrice, frame, daysBuilt, performance, untouchable, plugin, menuSize, screenWidth, screenHeight, button, shortcut

-- Adds options to the settings.
function script:settings()
  return {
    {
      name = 'Toggle WAIV',
      value = store.toggleMenu,
      onChange = function(newState) store.toggleMenu = newState end
    },
	{
      name = 'Shortcut Button',
      value = store.toggleButton,
      onChange = function(newState) store.toggleButton = newState end
    },
	{
      name = 'Show Crosshair',
      value = store.showCrosshair,
      onChange = function(newState) store.showCrosshair = newState end
    },
	{
      name = 'Show Frame',
      value = store.showFrame,
      onChange = function(newState) store.showFrame = newState end
    },
	{
      name = 'Performance Mode',
      value = store.performanceMode,
      onChange = function(newState) store.performanceMode = newState end
    },
	{
      name = 'Ignore RCI',
      value = store.ignoreRCI,
      onChange = function(newState) store.ignoreRCI = newState end
    },
	{
      name = 'Easy Selection',
      value = store.easySelection,
      onChange = function(newState) store.easySelection = newState end
    }
  }
end

function script:buildCityGUI()
  -- Adds the shortcut button if store.toggleButton is true
  if store.toggleButton == true then
	local sidebar = GUI.get('sidebarLine')
    local size = sidebar:getFirstPart():getChild(2):getWidth()
    button = sidebar:getFirstPart():addButton{
    width = size,
    height = size,
    icon = Icon.HELP,
    frameDefault = Icon.NP_BLUE_BUTTON,
    frameDown = Icon.NP_BLUE_BUTTON_PRESSED,
    onClick = function()
	  if store.toggleMenu == true then
	    store.toggleMenu = false
	  else
	    store.toggleMenu = true
	  end
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
    if store.toggleMenu == true then
	    store.toggleMenu = false
	  else
	    store.toggleMenu = true
	  end
  end
    }
  -- Here is where the keyboard shortcut is defined. Feel free to change this to whatever you like.
  shortcut:addHotkey(Keys.SEMICOLON)
  -- This part moves the button offscreen. For some reason, a button with size 0 is still visible, which is why I have done this.
  shortcut:setPosition(-50, -50)
end

local framesCount = 10
function script:update()
  -- Turns the button invisible if Hide UI mode is used
  if store.toggleButton == true then
  button:setVisible(not TheoTown.SETTINGS.hideUI)
  end
  
  --Checks if Hide UI mode is being used
  if TheoTown.SETTINGS.hideUI ==  false then
  
    screenWidth, screenHeight = Drawing.getSize()
	
    -- Draws the crosshair if store.showCrosshair is true
	if store.showCrosshair == true then
	  Drawing.drawLine ((screenWidth/2)-4, screenHeight/2, (screenWidth/2)+4, screenHeight/2, 1)
	  Drawing.drawLine (screenWidth/2, (screenHeight/2)-4, screenWidth/2, (screenHeight/2)+4, 1)
	end
  
    -- Checks if the menu has been enabled
    if store.toggleMenu == true then
	  x, y = City.getView()
	  x = math.floor(x+0.5)
      y = math.floor(y+0.5)
	  
	  -- Offsets the x and y coordinates if the city is rotated
	  if City.getRotation() == 1 then
	    x, y = City.getWidth()-1-y, x
	  elseif City.getRotation() == 2 then
	    x, y = City.getWidth()-1-x, City.getWidth()-1-y
	  elseif City.getRotation() == 3 then
		x, y = y, City.getWidth()-1-x
	  end
	
	-- Finds another building on an adjacent tile if the current tile is empty and store.easySelection is true
	if Tile.isBuilding(x, y) == false and store.ignoreRCI == false then
	  if store.easySelection == false then
	    return
	  elseif Tile.isBuilding(x+1, y) == true then
	    x = x+1
	  elseif Tile.isBuilding(x, y+1) == true then
	    y = y+1
	  elseif Tile.isBuilding(x-1, y) == true then
	    x = x-1
	  elseif Tile.isBuilding(x, y-1) == true then
	    y = y-1
	  elseif Tile.isBuilding(x+1, y+1) == true then
	    x = x+1
		y = y+1
	  elseif Tile.isBuilding(x-1, y-1) == true then
	    x = x-1
		y = y-1
	  elseif Tile.isBuilding(x-1, y+1) == true then
	    x = x-1
		y = y+1
	  elseif Tile.isBuilding(x+1, y-1) == true then
	    x = x+1
		y = y-1
	  else
	    return
	  end
	end
	
	-- Does the same thing as before, but will only check for non-RCI buildings
	if store.ignoreRCI == true then
	if Tile.isBuilding(x, y) == false or Tile.getBuildingDraft(x, y):isRCI() == true then
	  if store.easySelection == false then
	    return
	  elseif Tile.isBuilding(x+1, y) == true and Tile.getBuildingDraft(x+1, y):isRCI() == false then
	    x = x+1
	  elseif Tile.isBuilding(x, y+1) == true and Tile.getBuildingDraft(x, y+1):isRCI() == false then
	    y = y+1
	  elseif Tile.isBuilding(x-1, y) == true and Tile.getBuildingDraft(x-1, y):isRCI() == false then
	    x = x-1
	  elseif Tile.isBuilding(x, y-1) == true and Tile.getBuildingDraft(x, y-1):isRCI() == false then
	    y = y-1
	  elseif Tile.isBuilding(x+1, y+1) == true and Tile.getBuildingDraft(x+1, y+1):isRCI() == false then
	    x = x+1
		y = y+1
	  elseif Tile.isBuilding(x-1, y-1) == true and Tile.getBuildingDraft(x-1, y-1):isRCI() == false then
	    x = x-1
		y = y-1
	  elseif Tile.isBuilding(x-1, y+1) == true and Tile.getBuildingDraft(x-1, y+1):isRCI() == false then
	    x = x-1
		y = y+1
	  elseif Tile.isBuilding(x+1, y-1) == true and Tile.getBuildingDraft(x+1, y-1):isRCI() == false then
	    x = x+1
		y = y-1
	  else
	    return
	  end
	end
	end
	
	draft = Tile.getBuildingDraft(x, y)
	
	-- Checks if perfoance mode is disabled or if framesCount is at 10
	if framesCount == 10 or store.performanceMode == false then
	  name = draft:getTitle()
      buildingType = draft:getType()
	  monthlyPrice = draft:getMonthlyPrice()
	  frame = Tile.getBuildingFrame (x, y)
	  daysBuilt = Tile.getBuildingDaysBuilt (x, y)
	  performance = Tile.getBuildingPerformance (x, y)
	  untouchable = Tile.isBuildingUntouchable (x, y)
	  plugin = draft:isPlugin ()
	  menuSize = 3
		
	  -- Capitalizes the first letter of the building's type
	  buildingType = string.upper(string.sub(buildingType, 1, 1)) .. string.sub(buildingType, 2)
	  -- Inverts the monthly price variable
	  monthlyPrice = monthlyPrice*-1
	  if monthlyPrice > 0 then
	    monthlyPrice = ", +" .. monthlyPrice .. "T"
	  elseif monthlyPrice < 0 then
	    monthlyPrice = ", " .. monthlyPrice .. "T"
	  else
	    monthlyPrice = ""
	  end
	  if store.showFrame == true then
	    frame = " (" .. frame .. ")"
	  else
	    frame = ""
	  end
	  if plugin == true then
	    plugin = ", Plugin"
	  else
	    plugin = ""
	  end
	  if performance == 1 then
	    performance = ""
	  else
	    performance = math.floor((performance*100)+0.5) .. "%"
		menuSize = menuSize+1
      end
	  if performance == "" and untouchable == true then
	    untouchable = "Untouchable"
		menuSize = menuSize+1
	  else
	    untouchable = ""
	  end
	  end
	  
	  -- Draws the GUI on-screen
	  Drawing.drawNinePatch (NinePatch.BLUE_BUTTON_PRESSED, (screenWidth/2)-53, 1, 106, 9*menuSize+6)
	  Drawing.drawText (name .. frame, (screenWidth/2), 4, Font.SMALL, 0.5)
	  Drawing.drawText (buildingType .. plugin, (screenWidth/2), 13, Font.SMALL, 0.5)
	  Drawing.drawText (daysBuilt .. " Days" .. monthlyPrice, (screenWidth/2), 22, Font.SMALL, 0.5)
	  Drawing.drawText (performance .. untouchable, (screenWidth/2), 31, Font.SMALL, 0.5)
	end
  end
  framesCount = framesCount+1
  if framesCount > 10 then
	framesCount = 0
  end
end