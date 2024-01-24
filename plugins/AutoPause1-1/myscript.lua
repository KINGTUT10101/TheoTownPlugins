-- Allows the plug-in to save information as long as the values start with "save."
local save = Util.optStorage(TheoTown.getStorage(), script:getDraft():getId())

-- Predefined variabled for later
local enteredCity = false


-- Sets the setting to default if it is undefined
if save.toggleAutoPause == nil then
  save.toggleAutoPause = true
end


-- Adds an option to the settings.
function script:settings()
  return {
    {
      name = 'Pause upon entering city',
      value = save.toggleAutoPause,
      onChange = function(newState) save.toggleAutoPause = newState end
    }
  }
end


-- Pauses the game when a city is entered if the setting is turned on.
function script:enterCity()
  if save.toggleAutoPause == true and enteredCity == false then
    City.setSpeed(0)
	enteredCity = true
  end
end


-- Sets enteredCity to false when the player leaves a city
function script:leaveCity()
  enteredCity = false
end