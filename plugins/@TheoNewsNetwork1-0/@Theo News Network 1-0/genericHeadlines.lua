-- Allows the plug-in to save information as long as the values start with "newsPack."
local newsPack = Util.optStorage(TheoTown.getStorage(), script:getDraft():getId())


-- These variables save the plug-in's settings.
if newsPack.newsPackDefault == nil then
	newsPack.newsPackDefault = true
end
if newsPack.newsPackAds == nil then
	newsPack.newsPackAds = true
end
if newsPack.newsPackTips == nil then
	newsPack.newsPackTips = true
end
if newsPack.newsPackMonthly == nil then
	newsPack.newsPackMonthly = true
end


function script:settings()
	return {
		{
			name = 'Toggle Default Headlines',
			value = newsPack.newsPackDefault,
			onChange = function(newState)
				newsPack.newsPackDefault = newState
				Debug.toast ('Restart to see effect')
			end
		},
		{
			name = 'Toggle Advertisement Headlines',
			value = newsPack.newsPackAds,
			onChange = function(newState)
				newsPack.newsPackAds = newState
				Debug.toast ('Restart to see effect')
			end
		},
		{
			name = 'Toggle Tip Headlines',
			value = newsPack.newsPackTips,
			onChange = function(newState)
				newsPack.newsPackTips = newState
				Debug.toast ('Restart to see effect')
			end
		},
		{
			name = 'Toggle OG Headlines',
			value = newsPack.newsPackMonthly,
			onChange = function(newState)
				newsPack.newsPackMonthly = newState
				Debug.toast ('Restart to see effect')
			end
		}
	}
end


function script:earlyInit ()
	--[[ Creates the headline arrays. I moved them here to make the
	original lua file cleaner. Also, the main array is public, so other plug-ins can
	add new headlines to it. ]]--
	
	headlines = Array {
		"You have disabled all the headline packs!",
		"Please go into Settings/Plugins and select a headline pack to use",
		"Theo News Network is out of headlines, please enable some in the settings",
		"Man, it sure is boring around here! Try enabling some headline packs",
		"Local mayor decides to disable all headline packs, chaos ensues",
		"Error: No headline packs enabled"
	}
	
	if newsPack.newsPackDefault == true then
		local defaultHeadlines = Array {
			"Thank You For Tuning Into Theo News Network!",
			"Annual Code Hunt Begins, Hundreds Start Worshipping A Giant Sloth",
			"Local Tries To Start New Prison System, Fails Miserably",
			"Local Resident Stoned To Death After Claiming They Dislike Pickled Goods",
			"Llamas Are Out,... And Pickles Are In!",
			"Are White Shirts And Black Ties The Next Wave Of Fashion?",
			"Are You Prepared For Our Future Alien Overlords? Find out at 10!",
			"Neighbor City Finally Replaces S-Bahn System With Modern Urban Railway",
			"Local Man Can't Go Fishing, Blames The Ice",
			"Clocks Around The Neighborhood Stuck At 12:00PM, Experts Baffled",
			"Kingsington President Rebuilds Mauville After Yet Another Devastating Disaster",
			"Old Tramway Cars Refurbished; Plans For A New Train System Underway",
			"Bepis Or Conke? Expert Dentists Say Neither",
			"Computer Virus Spreads Across The Worldwide Web; Online Toilet Paper Stores Become Inaccessible",
			"Florida Man Caught Pirating TheoTown; Later Sentenced To Life In Prison",
			"Safety Meeting Ends In Tragic Accident",
			"Worldwide Population To Double In Fifty Years; Babies To Blame",
			"Police Raid Local Gun Store; Find Weapons",
			"Man Found Dead In Graveyard; Officer Reprimanded For Graverobbing",
			"Scientist Reaffirms That Yes, Birds Are Real",
			"New Study Reveals Birds As Government Drones",
			"New Study Reveals Correlation Between Blindness and Failed Driver Tests",
			"New Doctor Claims He's Immune To Apples; Citizens Beware!"
		}
		headlines:addAll (defaultHeadlines)
	end
	
	if newsPack.newsPackAds == true then
		local adsHeadlines = Array {
			"Age Of Sail 2: Now Available In Stores Near You!",
			"TheoTown Prison Expansion: Available Summer 2025",
			"Sale: Nature Pack Fertilizer 18% Off!",
			"The Tramway Set: The Perfect Toy For Kids 3 and Up",
			"Invest In Depolluters, Invest In A Better Future!",
			"Come Visit Beautiful Cytopia! We're Famous For Our Lush Forests And Beautiful Snail Species",
			"Tune Into The An On Weekdays At 6AM EST",
			"Invest In Snailcoin,... Before It's Too Late!",
			"TheoTown VR: Taking City Building To The Next Level",
			"28 Celebs Who Painted Their Houses Orange: You Won't Believe #17!",
			"CLICK HERE TO DOWNLOAD MORE RAM FOR FREE!",
			"I paid for this adspace so you wouldn't have to see a real advertisement",
			"Mr. ABab's Abstract Art Emporium: $29.98 Per Person, 3 And Under Get In For Free"
		}
		headlines:addAll (adsHeadlines)
	end
	
	if newsPack.newsPackTips == true then
		local tipsHeadlines = Array {
			"Tip: Type 'hack' Into The Console For A Surprise",
			"Tip: Type 'cheat' Into The Console For A Surprise",
			"Tip: Type 'whoami' Into The Console For A Surprise",
			"Tip: Buildings Cost Less in Easier Gamemodes",
			"Tip: Read Plug-in Descriptions Before Downloading Them",
			"Tip: Trees Reduce Pollution From Nearby Buildings",
			"Tip: Missile Silos Attract Meteors,... And Worse",
			"Tip: Increase Supply Happiness By Building Public Transportation",
			"Tip: Placing Buildings In Easy Mode Is Instant",
			"Tip: Destroy The Sea Rocks For Extra Cash",
			"Tip: The Nature Pack Adds People That Walk On The Sidewalks",
			"Tip: A Clock Can Be Enabled By Downloading The In-Game Clock Plug-in",
			"Tip: The Green, Blue, And Yellow Bars On The Side Indicate Your Citizens' Demand For Zones",
			"Tip: The Big Pickle Can Be Defeated By Destroying All His Small Pickles",
			"Tip: Always Place Fire Departments And Water Towers Next To Nuclear Power Plants",
			"Tip: Some Plug-ins Can Only be Found On The TheoTown Forums",
			"Tip: The Easy Weather Selector Plug-in Allows You To Change The Weather Without A Weather Machine",
			"Tip: The Autopause Plug-in Will Pause The Game When You Enter A City",
			"Tip: The Automatic Winter Plug-in Will Change The Season Based On The In-Game Date",
			"Tip: The City Notes Plug-in Is Great For Writing Down Plans For Your City",
			"Tip: The Advanced Information Plug-in Adds Useful Shortcuts To The Sidebar",
			"Tip: The Road Authority Building Makes Roads And Tunnels Cheaper",
			"Tip: Special Buildings Can Be Built During Certain Holiday Months",
			"Tip: A Special Helipad Can Be Found By Opening Christmas Presents"
		}
		headlines:addAll (tipsHeadlines)
	end
	
	if newsPack.newsPackMonthly == true then
		local monthlyNewsHeadlines = Array{
			"Kitty Kibble Shortage Drives Local Cats To Riot",
			"What Is The Meaning Of Life? Asks Local Habitant, Advice Llama Stumped",
			"Cheese Cutting Related To Broccoli, Says Local Scientist", 
			"New Pickle Legislation Seeks To Ban Assualt Pickles",
			"Giant Snail Found Underground, Keep Reading For More Details",
			"Have You Been Keeping Up On Your Homework? New Study Says Otherwise",
			"Trumpet Found To Be The Worst Instrument After Hours of Heated Debate",
			"Surprise Mechanics And Their Close Likeness To Loot Boxes; A Critical Analysis",
			"From Cucumber Onwards: How To Properly Raise Your Pet Pickle",
			"Is ForkNife Healthy For Kids? Keep Reading To Find Out",
			"70 Year Old Tramway System Finally Replaced With Modern S-Bahn",
			"New Study Links Cucumbers and Vinegar To Happiness",
			"New Cure To Money Loss Found: Don't Download The Prison Plug-in Without Reading!",
			"To The Moon and Back: One Man's Tragic Journey Through Space",
			"Sorry Everyone, The Ice Cream Machine Is Broke",
			"How To Get Your Bachelor's Degree Before You're Twenty",
			"New Coffee Shop Opens, Prices Outrageous As Usual",
			"Ever Try Gas Station Food? Not As Bad As You May Think",
			"New PearPhone Model Released: Same Product, But With THREE Cameras",
			"Procrastination, And Why I'm Releasing The Rest of This Paper Tommorow",
			"Scientist Claims We're Living In A Simulation, Gets Called Crazy By His Peers",
			"New Cheese Factory Opens Next To Knife Plant. The Streets Will Never Smell The Same Again",
			"Group Of Bats Found In My Attic. What Will Those Crazy Neighbors Do To Me Next?!",
			"Popular Block-Crafter Game Pulls In Millions Of Players Daily",
			"Back In The Day, Us Respectable Journalists Didn't Have Your Fancy Technology, Just Our Ink And Patience!",
			"Are Diamonds Hurting The Gaming Industry?",
			"Man Claims To Have Proof Of Aliens, Disappears Shortly Afterwards",
			"Am I Real? Are You Real?  Maybe We're In A Video Game..."
		}
		headlines:addAll (monthlyNewsHeadlines)
	end
end