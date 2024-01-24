-- Allows the plug-in to save information. Don't change this part!
local newsPack = Util.optStorage(TheoTown.getStorage(), script:getDraft():getId())

-- You will need to choose a unique suffix for every instance of "newsPack.example" (There are 5).
-- Change the "example" part, while leaving the "newsPack." part intact.
if newsPack.community == nil then -- Update the variable name (1/5)
	newsPack.community = true -- Update the variable name (2/5)
end

-- This part adds an option in the settings that'll toggle your headlines on/off.
function script:settings()
	return {
		{
			name = "(TNN) Toggle Community Headlines", -- You can use any title you want here
			value = newsPack.community, -- Update the variable name (3/5)
			onChange = function(newState)
				newsPack.community = newState -- Update the variable name (4/5)
				Debug.toast ("Restart to see effect")
			end
		}
	}
end


function script:earlyInit ()
	if newsPack.community == true then -- Update the variable name (5/5)
		-- Here you can add all your custom headlines!
		-- You can add as many headlines as you wish, but I'd recommend having more than one.
		-- Just make sure you're following the lua table's format.
		-- Everything needs quotes around it, and every line but the last needs a comma.
		local customHeadlines = Array {
			"Man Eats Six Pounds Of Mac-n-Cheese; Mistakenly Wins Eating Competition",
			"Developer Accused Of Unreadable Code Refuses To Comment",
			"Come down to [BIG SHOT] autos where the prices are [6 payments of $19.95] and the staff are [[hyperlink blocked]]",
			"Man Steals Thousands Worth of NFTs; Later Thanked By Head Of Police",
			"Popular Celeberty Revealed As Abnormally Large Watermelon In Failed Ballroom Dance",
			"Ohio Wins USA's Most Forgettable State' Award 44th Year In A Row",
			"Scientists Find Proof RGB Boosts PC Performance In Quadruple-Blind Study",
			"DSA's Top Rocket Scientist Requests More Oil",
			"See Garbage On The Roads? Call A Garbage Truck!",
			"Developer Accused Of Unreadable Code Refuses To Comment"
		}
		headlines:addAll (customHeadlines)
	end
end