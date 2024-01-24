PW=0
PH=0
PJ=0
HCO=0
CO=0
MHO=0
YO=0
GO=0

PR=0
FN=0
EF=0
RC=0
HP=0

MHF=0
YF=0
GF=0

PMF=0
PEF=0

ST=0
DL=0
-- Sets the number variables

local PNI=Draft.getDraft("$anim_people_source01"):getFrame (21)
-- Sets the frame variables

function Satisfaction (service, prisoners)
satisfaction=100*(service/prisoners)
if satisfaction~=satisfaction then
satisfaction=50
end
if satisfaction>100 then
satisfaction=100
end
return satisfaction
end
-- Creates a custom function that'll help calculate prisoner happiness

function Capacity (prisoners, service)
capacity=100*(prisoners/service)
if capacity~=capacity then
capacity=prisoners
end
if capacity>=100 then
capacity=100
end
return capacity
end
-- Creates a custom function that'll determine how full a service is



function script:update ()

prison = Util.optStorage(City.getStorage(), script:getDraft():getId())

if prison.onoff == nil then
prison.onoff = 1
end

TheoTown.registerCommand("Prison Enable", function()
prison.onoff = 1
return "Prison Expansion Enabled"
end)

TheoTown.registerCommand("Prison Disable", function()
prison.onoff = 0
return "Prison Expansion Disabled"
end)

ST=1*City.countBuildings (Draft.getDraft ("armory1.kt101"))+2*City.countBuildings (Draft.getDraft ("armory2.kt101"))+3*City.countBuildings (Draft.getDraft ("armory3.kt101"))

RC=5*City.countBuildings (Draft.getDraft ("office1.kt101"))+10*City.countBuildings (Draft.getDraft ("office2.kt101"))+15*City.countBuildings (Draft.getDraft ("office3.kt101"))+5*City.countBuildings (Draft.getDraft ("office4.addon"))+5*City.countBuildings (Draft.getDraft ("office5.addon"))+5*City.countBuildings (Draft.getDraft ("office6.addon"))+5*City.countBuildings (Draft.getDraft ("office7.addon"))+10*City.countBuildings (Draft.getDraft ("office8.addon"))+10*City.countBuildings (Draft.getDraft ("office9.addon"))+10*City.countBuildings (Draft.getDraft ("office10.addon"))+10*City.countBuildings (Draft.getDraft ("office11.addon"))+15*City.countBuildings (Draft.getDraft ("office12.addon"))+15*City.countBuildings (Draft.getDraft ("office13.addon"))+15*City.countBuildings (Draft.getDraft ("office14.addon"))+15*City.countBuildings (Draft.getDraft ("office15.addon"))
-- This detects the chance of release percentage from parole offices

if RC>50 then
RC=50
end
-- This makes sure RC never goes above 50%

if City.getXp () >= 15000 or City.isSandbox () then

PW=.05*City.getPeople ()+(((1-City.getHappiness ())/10)*City.getPeople ())-((RC/1000)*City.getPeople ())
-- Sets PW for the next day

end

if PW<=0 then
PW=0
end
-- Makes sure PW doesn't go below 0

if prison.onoff == 0 then
PW=0
end
-- Sets PW to 0 when the Prison Disable is used, essentially disabling the prison system

CO=250*City.countBuildings (Draft.getDraft ("wardensoffice.kt101"))+150*City.countBuildings (Draft.getDraft ("cell1.kt101"))+300*City.countBuildings (Draft.getDraft ("cell2.kt101"))+600*City.countBuildings (Draft.getDraft ("cell3.kt101"))+150*City.countBuildings (Draft.getDraft ("cell4.addon"))+150*City.countBuildings (Draft.getDraft ("cell5.addon"))+150*City.countBuildings (Draft.getDraft ("cell6.addon"))+150*City.countBuildings (Draft.getDraft ("cell7.addon"))+300*City.countBuildings (Draft.getDraft ("cell8.addon"))+300*City.countBuildings (Draft.getDraft ("cell9.addon"))+300*City.countBuildings (Draft.getDraft ("cell10.addon"))+300*City.countBuildings (Draft.getDraft ("cell11.addon"))+600*City.countBuildings (Draft.getDraft ("cell12.addon"))+600*City.countBuildings (Draft.getDraft ("cell13.addon"))+600*City.countBuildings (Draft.getDraft ("cell14.addon"))+600*City.countBuildings (Draft.getDraft ("cell15.addon"))
-- This detects the total amount of cell space available

HCO=250*City.countBuildings (Draft.getDraft ("holdingcell1.kt101"))+500*City.countBuildings (Draft.getDraft ("holdingcell2.kt101"))+1000*City.countBuildings (Draft.getDraft ("holdingcell3.kt101"))+250*City.countBuildings (Draft.getDraft ("holdingcell4.addon"))+250*City.countBuildings (Draft.getDraft ("holdingcell5.addon"))+250*City.countBuildings (Draft.getDraft ("holdingcell6.addon"))+250*City.countBuildings (Draft.getDraft ("holdingcell7.addon"))+500*City.countBuildings (Draft.getDraft ("holdingcell8.addon"))+500*City.countBuildings (Draft.getDraft ("holdingcell9.addon"))+500*City.countBuildings (Draft.getDraft ("holdingcell10.addon"))+500*City.countBuildings (Draft.getDraft ("holdingcell11.addon"))+1000*City.countBuildings (Draft.getDraft ("holdingcell12.addon"))+1000*City.countBuildings (Draft.getDraft ("holdingcell13.addon"))+1000*City.countBuildings (Draft.getDraft ("holdingcell14.addon"))+1000*City.countBuildings (Draft.getDraft ("holdingcell15.addon"))
-- This detects the total amount of holding cell space available

MHO=250*City.countBuildings (Draft.getDraft ("wardensoffice.kt101"))+300*City.countBuildings (Draft.getDraft ("messhall1.kt101"))+600*City.countBuildings (Draft.getDraft ("messhall2.kt101"))+1200*City.countBuildings (Draft.getDraft ("messhall3.kt101"))+300*City.countBuildings (Draft.getDraft ("messhall4.addon"))+300*City.countBuildings (Draft.getDraft ("messhall5.addon"))+300*City.countBuildings (Draft.getDraft ("messhall6.addon"))+300*City.countBuildings (Draft.getDraft ("messhall7.addon"))+600*City.countBuildings (Draft.getDraft ("messhall8.addon"))+600*City.countBuildings (Draft.getDraft ("messhall9.addon"))+600*City.countBuildings (Draft.getDraft ("messhall10.addon"))+600*City.countBuildings (Draft.getDraft ("messhall11.addon"))+1200*City.countBuildings (Draft.getDraft ("messhall12.addon"))+1200*City.countBuildings (Draft.getDraft ("messhall13.addon"))+1200*City.countBuildings (Draft.getDraft ("messhall14.addon"))+1200*City.countBuildings (Draft.getDraft ("messhall15.addon"))
-- This detects the total amount of mess hall space available

YO=250*City.countBuildings (Draft.getDraft ("wardensoffice.kt101"))+500*City.countBuildings (Draft.getDraft ("yard1.kt101"))+1000*City.countBuildings (Draft.getDraft ("yard2.kt101"))+2000*City.countBuildings (Draft.getDraft ("yard3.kt101"))+500*City.countBuildings (Draft.getDraft ("yard4.addon"))+500*City.countBuildings (Draft.getDraft ("yard5.addon"))+500*City.countBuildings (Draft.getDraft ("yard6.addon"))+500*City.countBuildings (Draft.getDraft ("yard7.addon"))+1000*City.countBuildings (Draft.getDraft ("yard8.addon"))+1000*City.countBuildings (Draft.getDraft ("yard9.addon"))+1000*City.countBuildings (Draft.getDraft ("yard10.addon"))+1000*City.countBuildings (Draft.getDraft ("yard11.addon"))+2000*City.countBuildings (Draft.getDraft ("yard12.addon"))+2000*City.countBuildings (Draft.getDraft ("yard13.addon"))+2000*City.countBuildings (Draft.getDraft ("yard14.addon"))+2000*City.countBuildings (Draft.getDraft ("yard15.addon"))
-- This detects the total amount of yard space available

GO=250*City.countBuildings (Draft.getDraft ("wardensoffice.kt101"))+200*City.countBuildings (Draft.getDraft ("guards1.kt101"))+400*City.countBuildings (Draft.getDraft ("guards2.kt101"))+800*City.countBuildings (Draft.getDraft ("guards3.kt101"))+1000*City.countBuildings (Draft.getDraft ("tower1.kt101"))+2000*City.countBuildings (Draft.getDraft ("tower2.kt101"))+4000*City.countBuildings (Draft.getDraft ("tower3.kt101"))+1000*City.countBuildings (Draft.getDraft ("tower4.addon"))+1000*City.countBuildings (Draft.getDraft ("tower5.addon"))+1000*City.countBuildings (Draft.getDraft ("tower6.addon"))+1000*City.countBuildings (Draft.getDraft ("tower7.addon"))+2000*City.countBuildings (Draft.getDraft ("tower8.addon"))+2000*City.countBuildings (Draft.getDraft ("tower9.addon"))+2000*City.countBuildings (Draft.getDraft ("tower10.addon"))+2000*City.countBuildings (Draft.getDraft ("tower11.addon"))+4000*City.countBuildings (Draft.getDraft ("tower12.addon"))+4000*City.countBuildings (Draft.getDraft ("tower13.addon"))+4000*City.countBuildings (Draft.getDraft ("tower14.addon"))+4000*City.countBuildings (Draft.getDraft ("tower15.addon"))
-- This detects the total amount of guard power available

if PW>CO then
PJ=CO
PW=PW-CO

elseif PW<=CO then
PJ=PW
PW=0
end

if PW>HCO then
PH=HCO
PW=PW-HCO

elseif PW<=HCO then
PH=PW
PW=0
end

-- This part sets PH and PJ for the next day based on PW

PEF=PW
-- Calculates PEF

if MHO-(PJ+PH)<0 then
MHF=-1*(MHO-(PJ+PH))
end
if YO-(PJ+PH)<0 then
YF=-1*(YO-(PJ+PH))
end
if GO-(PJ+PH)<0 then
GF=-1*(GO-(PJ+PH))
end

if MHO-(PJ+PH)>=0 then
MHF=0
end
if YO-(PJ+PH)>=0 then
YF=0
end
if GO-(PJ+PH)>=0 then
GF=0
end
FN=MHF+YF+GF
-- This adds all of the fines together

PR=(RC/1000)*City.getPeople ()
-- Sets PR

HP=(Satisfaction (MHO, PH+PJ)+Satisfaction (YO, PH+PJ)+Satisfaction (GO, PH+PJ)+(100*(PH+PJ)/((4*PW)+(1.5*PH)+PJ))+(100*(PH+PJ)/((4*PW)+(1.5*PH)+PJ)))/5

if PH+PJ==0 then
HP=50
end
-- Calculates prisoner happiness

if City.getXp () >= 100000 or City.isSandbox () then
DL=(.00001*(100-HP))
else
DL=0
end
-- Calculates the danger level, which is used to influence the chance of a prison riot

if PH+PJ==0 then
DL=0
end
-- Sets the danger level to 0 if there are no prisoners in the system


if DL>.001 then
DL=.001
end
-- Makes sure DL doesn't go over 1

City.setFunVar ("fTP", PW+PH+PJ)
City.setFunVar ("fP", PH+PJ)
City.setFunVar ("fPW", PW)
City.setFunVar ("fPH", PH)
City.setFunVar ("fPJ", PJ)
City.setFunVar ("fHCO", HCO)
City.setFunVar ("fCO", CO)
City.setFunVar ("fTCO", HCO+CO)
City.setFunVar ("fMHO", MHO)
City.setFunVar ("fYO", YO)
City.setFunVar ("fGO", GO)
City.setFunVar ("fRC", RC)
City.setFunVar ("fPR", PR)
City.setFunVar ("fPMF", FN)
City.setFunVar ("fPEF", PEF)
City.setFunVar ("fHP", HP)
City.setFunVar ("fST", ST)
City.setFunVar ("fDL", DL*100000)
-- This part sets the fun variables that are used in building descriptions.

end



function script.nextDay ()

if prison.onoff == 1 then
City.spendMoney(((PEF+FN)/30), nil, nil, "$budget_prison00")

if City.getXp () > 12600 or City.isSandbox () then
-- Only allows the notification to function after a certain XP threshold
if City.countBuildings (Draft.getDraft ("WardensOffice.kt101"))==0 then
City.showNotification{icon=PNI, id="warden.notif", showOnce=true, text="I would recommend building a Warden's Office before the first prisoners arrive, mayor."}
end
end

if City.getXp () >= 15000 then
-- Only allows the notification to function after after a certain XP threshold
City.showNotification{icon=PNI, showOnce=true, id="FirstGroup.notif", text="Here comes our first group of prisoners, mayor!"}
end

if City.getXp () > 84350 then
-- Only allows the notification to function after after a certain XP threshold
City.showNotification{icon=PNI, showOnce=true, id="Armory.notif", text="You should build some armories in case things our prisoners get out of hand."}
end

if City.getXp () >= 100000 then
-- Only allows the notification to function after after a certain XP threshold
City.showNotification{icon=PNI, showOnce=true, id="RiotWarning.notif", text="Our prisons feel a bit... Uneasy. I expect to see some prison riots in the future."}
end
end

end



function script.nextMonth ()

if City.getMonth ()%3 == 0 then
if prison.onoff == 1 then
if PEF>0 then
City.showNotification{icon=PNI, showOnce=false, id="Exporting Prisoners.notif", text="We are losing money due to prisoner exportation fees. Please build more cells!"}
end

if Capacity (PH+PJ, HCO+CO)>=85 or Capacity (PH+PJ, MHO)>=85 or Capacity (PH+PJ, YO)>=85 or Capacity (PH+PJ, GO)>=85 then
City.showNotification{icon=PNI, showOnce=false, id="ServiceNearCapacity.notif", text="Our prisons are running out of space to accommodate all these inmates. Please expand your prisons before we start getting fined!"}
end
end
end

end


-- Wow, this code is messy. I guess that's what happens when this is your first big Lua project.
