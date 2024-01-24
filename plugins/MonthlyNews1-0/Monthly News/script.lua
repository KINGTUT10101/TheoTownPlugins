local news=Array{
"Kitty Kibble Shortage Drives Local Cats To Riot",
"What Is The Meaning Of Life? Asks Local Habitant, Advice Llama Stumped",
"Cheese Cutting Related To Broccoli, Says Local Scientist", 
"New Pickle Legislation Seeks To Ban Assualt Pickles",
"Giant Snail Found Underground, Keep Reading For More Details",
"Have You Been Keeping Up On Your Homework? New Study Says Otherwise",
"Trumpet Found To Be The Worst Instrument After Hours of Heated Debate in Downtown",
"Surprise Mechanics and Their Close Likeness To Loot Boxes",
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
"Main Claims To Have Proof Of Aliens, Disappears Shortly Afterwards",
"Am I Real? Are You Real?  Maybe We're In A Video Game..."
}
-- Sets the array that will be used in the notification

function script:nextMonth ()

local DI=Draft.getDraft("news.icon"):getFrame(0)
--Sets the notification icon

City.showNotification{icon=DI,showOnce=false, id=news.notif, text=news:pick ()}

end
