local coordSave = Util.optStorage(TheoTown.getStorage(), script:getDraft():getId())
-- Allows the plug-in to save information as long as the values start with "coordSave."


coordSave.coordToggle = coordSave.coordToggle or true
coordSave.coordPosition = coordSave.coordPosition or 3
-- Sets the plug-in's default settings if no previous values have been detected

coordSave.coordReset = false


local width, height, x, y, Xcoord, Ycoord
-- Defines these variables ahead of time


function script:settings()
  return {
	{
      name = 'Toggle Coordinates',
      value = coordSave.coordToggle,
      onChange = function(newState) coordSave.coordToggle = newState end
    },
	{
      name = 'Coordinates Position',
      value = coordSave.coordPosition,
      values = {0, 1, 2, 3},
      valueNames = {'Far-Left', 'Left', 'Right', 'Far-Right'},
      onChange = function(newState) coordSave.coordPosition = newState end
    },
	{
      name = 'Reset Coordinates Settings',
      value = coordSave.coordReset,
      onChange = function(newState)
	    coordSave.coordToggle = true
		coordSave.coordPosition = 3
	    coordSave.coordReset = false
		Debug.toast ('Active coordinates reset!')
	  end
    }
  }
end


function script:update ()

if coordSave.coordToggle == true and not TheoTown.SETTINGS.hideUI then
width, height = Drawing.getSize()
x = 1
y = 1
Xcoord, Ycoord = City.getView()

Xcoord = math.floor(Xcoord+0.5)
Ycoord = math.floor(Ycoord+0.5)
-- Rounds the coordinates

if coordSave.coordPosition == 0 then
width = 0
x = 35
elseif coordSave.coordPosition == 1 then
width = 0
x = 80
elseif coordSave.coordPosition == 2 then
x = -113
elseif coordSave.coordPosition == 3 then
x = -82
end
-- Changes the position based on the settings

Drawing.setColor (0, 0, 0)

Drawing.drawText ("x: " .. Xcoord, width+x, height-46)
Drawing.drawText ("x: " .. Xcoord, width+x, height-47)

Drawing.drawText ("y: " .. Ycoord, width+x, height-33)
Drawing.drawText ("y: " .. Ycoord, width+x, height-34)

Drawing.reset ()

Drawing.drawText ("x: " .. Xcoord, width+x, height-48)

Drawing.drawText ("y: " .. Ycoord, width+x, height-35)

end
end
