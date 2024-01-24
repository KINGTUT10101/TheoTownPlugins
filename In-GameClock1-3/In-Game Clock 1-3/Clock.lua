local clockSave = Util.optStorage(TheoTown.getStorage(), script:getDraft():getId())
-- Allows the plug-in to save information as long as the values start with "clockSave."

clockSave.clockMode = clockSave.clockMode or 1
clockSave.clockPosition = clockSave.clockPosition or 3
clockSave.clockAbbreviated = clockSave.clockAbbreviated or false
-- Sets the plug-in's default settings if no previous values have been detected

clockSave.clockReset = false


local width, height, x, y, time, hour, minute, minuteBig, minuteSmall, period, divider
-- Defines these variables ahead of time


function script:settings()
  return {
	{
      name = 'Clock Mode',
      value = clockSave.clockMode,
      values = {0, 1, 2},
      valueNames = {'Off', '12-Hour', '24-Hour'},
      onChange = function(newState) clockSave.clockMode = newState end
    },
	{
      name = 'Clock Position',
      value = clockSave.clockPosition,
      values = {0, 1, 2, 3},
      valueNames = {'Far-Left', 'Left', 'Right', 'Far-Right'},
      onChange = function(newState) clockSave.clockPosition = newState end
    },
	{
      name = 'Abbreviate Time',
      value = clockSave.clockAbbreviated,
      onChange = function(newState) clockSave.clockAbbreviated = newState end
    },
	{
      name = 'Reset Clock Settings',
      value = clockSave.clockReset,
      onChange = function(newState)
	    clockSave.clockMode = 1
		clockSave.clockPosition = 3
		clockSave.clockAbbreviated = false
	    clockSave.clockReset = false
		Debug.toast ('In-game clock reset!')
	  end
    }
  }
end


function script:update ()

if clockSave.clockMode ~= 0 and not TheoTown.SETTINGS.hideUI then
width, height = Drawing.getSize()
x = -49
time = TheoTown.daytime*24
hour = time-(time%1)
hourBig = ""
minute = ((time%1)*60)-(((time%1)*60)%1)
minuteBig = (minute-(minute%10))/10
minuteSmall = minute%10
period = "AM"
divider = ":"

if clockSave.clockAbbreviated == true then
divider = ""
end
if clockSave.clockAbbreviated == true then
minuteBig = ""
minuteSmall = ""
end

if hour>11 then
period = "PM"
end
if clockSave.clockMode == 2 then
period = ""
if hour < 10 then
hourBig = 0
end
end
-- Formats the period based on the settings

if clockSave.clockMode == 1 then
if hour>12 then
hour = hour-12
end
if hour<1 then
hour = 12
end
end
-- Reformats the time if the plug-in is set to 12-hour mode

if clockSave.clockPosition == 0 then
width = 0
x = 3
elseif clockSave.clockPosition == 1 then
width = 0
x = 32
elseif clockSave.clockPosition == 2 then
x = -79
elseif clockSave.clockPosition == 3 then
x = -49
end
-- Changes the clock's position based on its settings

Drawing.setColor (0, 0, 0)

Drawing.drawText (hourBig .. hour .. divider .. minuteBig .. minuteSmall .. " " .. period, width+x, height-59)

Drawing.drawText (hourBig .. hour .. divider .. minuteBig .. minuteSmall .. " " .. period, width+x, height-58)

Drawing.reset ()

Drawing.drawText (hourBig .. hour .. divider .. minuteBig .. minuteSmall .. " " .. period, width+x, height-60)

end
end
