local button

function script:buildCityGUI()
  local sidebar = GUI.get('sidebarLine')
  local size = sidebar:getFirstPart():getChild(2):getWidth()
  button = sidebar:getFirstPart():addButton{
  width = size,
  height = size,
  icon = Draft.getDraft("AreaTool.kt101"):getPreviewFrame(1),
  frameDefault = Icon.NP_BLUE_BUTTON,
  frameDown = Icon.NP_BLUE_BUTTON_PRESSED,
  onClick = function()
	Draft.getDraft("AreaTool.kt101"):setVisible (true)
	City.createDraftDrawer(Draft.getDraft("AreaTool.kt101")).select()
	Draft.getDraft("AreaTool.kt101"):setVisible (false)
  end
  }
end

function script:event(x, y, level, event)
  if event == Script.EVENT_PLACED then
  Draft.getDraft("AreaTool.kt101"):setVisible (true)
  Builder.remove(x,y)
  -- I think this part might be cuaisng the FPS drops in build mode, but I'm not 100% sure
  local recent = City.createDraftDrawer(Draft.getDraft("AreaTool.kt101")):getHistory()[1]
  if recent == "AreaTool.kt101" then
    recent = City.createDraftDrawer(Draft.getDraft("AreaTool.kt101")):getHistory()[2]
  end
  local cost = Builder.getBuildingPrice(recent, x, y)
  if Draft.getDraft(recent):isBuilding() == true then
    if Draft.getDraft(recent).orig.diamondPrice == 0 then
	  if City.getMoney() >= cost or City.isSandbox() == true then
	    Builder.buildBuilding(recent, x, y)
          if Tile.getBuildingDraft(x, y) == Draft.getDraft(recent) then
            City.spendMoney(cost, x, y)
		  else
		    errorTimer = 5
		    errorNotPlaced = true
          end
      else
	  errorTimer = 5
	  errorNoMoney = true
      end
	end
  else
  errorTimer = 5
  errorNotBuilding = true
  end
  Draft.getDraft("AreaTool.kt101"):setVisible (false)
  end
end

function script:update()
  button:setVisible(not TheoTown.SETTINGS.hideUI)
  if errorTimer == nil then
    errorTimer = -1
  end
  if errorTimer == 0 then
    if errorNotBuilding == true then
	  errorNotBuilding = false
	  Debug.toast("Unsupported Item")
	  errorTimer = -1
	end
	if errorNoMoney == true then
	  errorNoMoney = false
	  if errorNotPlaced == true then
	    errorNotPlaced = false
	  end
	  Debug.toast("Out of Money")
	  errorTimer = -1
	end
	if errorNotPlaced == true then
	  errorNotPlaced = false
	  Debug.toast("Invalid Building / Placement")
	  errorTimer = -1
	end
  end
  errorTimer = errorTimer-1
end