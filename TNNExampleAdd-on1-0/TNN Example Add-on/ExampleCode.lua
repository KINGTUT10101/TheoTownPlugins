-- Allows the plug-in to save information. Don't change this part!
local newsPack = Util.optStorage(TheoTown.getStorage(), script:getDraft():getId())

-- You will need to choose a unique suffix for every instance of "newsPack.example" (There are 5).
-- Change the "example" part, while leaving the "newsPack." part intact.
if newsPack.example == nil then -- Update the variable name (1/5)
	newsPack.example = true -- Update the variable name (2/5)
end

-- This part adds an option in the settings that'll toggle your headlines on/off.
function script:settings()
	return {
		{
			name = "(TNN) Toggle Example Headlines", -- You can use any title you want here
			value = newsPack.example, -- Update the variable name (3/5)
			onChange = function(newState)
				newsPack.example = newState -- Update the variable name (4/5)
				Debug.toast ("Restart to see effect")
			end
		}
	}
end


function script:earlyInit ()
	if newsPack.example == true then -- Update the variable name (5/5)
		-- Here you can add all your custom headlines!
		-- You can add as many headlines as you wish, but I'd recommend having more than one.
		-- Just make sure you're following the lua table's format.
		-- Everything needs quotes around it, and every line but the last needs a comma.
		local customHeadlines = Array {
			"Hello World",
			"Test Test Test",
			"You can put anything here!",
			"Another headline? Sure!"
		}
		headlines:addAll (customHeadlines)
	end
end