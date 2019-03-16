myLootList = {}
lootWindow = nil
skillsButton = nil
function init()
  connect(g_game, { onGameEnd = onGameEnd })
  ProtocolGame.registerExtendedOpcode(135, function(protocol, opcode, buffer) showNow(buffer) end)
  
  skillsButton = modules.client_topmenu.addLeftGameToggleButton('lootButton', tr('AutoLoot') .. ' (Ctrl+W)', '/images/topbuttons/loot', requestShow)
  skillsButton:setWidth(32)
  skillsButton:setOn(false)
  
  g_keyboard.bindKeyDown('Ctrl+W', requestShow)
  
end

function requestShow()
    if lootWindow ~= nil then return end
	g_game.getProtocolGame():sendExtendedOpcode(135, "load/")
	skillsButton:setOn(true)
end

function onGameEnd()
	if lootWindow == nil then return end
	   lootWindow:hide()	
end

function salvar()

   skillsButton:setOn(false)
   lootWindow:destroy()	
   lootWindow = nil
   myLootList = {}

end

function terminate()
  disconnect(g_game, {
    onGameStart = online,
    onGameEnd = offline
  })

  g_keyboard.unbindKeyDown('Ctrl+W')

  lootWindow:destroy()
  lootWindow = nil
  myLootList = {}
end

function colectAll()
   skillsButton:setOn(false)
   if lootWindow:getChildById('getAll'):isChecked() then
	  lootWindow:getChildById('getAll'):setChecked(false)
   else
       lootWindow:getChildById('getAll'):setChecked(true)
   end
   
   local conc = lootWindow:getChildById('getAll'):isChecked() == true and "all" or "no"
   g_game.getProtocolGame():sendExtendedOpcode(135, "save/" .. conc)
   lootWindow:destroy()	
   lootWindow = nil
   myLootList = {}
end

function showNow(buffer)
  lootWindow = g_ui.displayUI('loot')
  lootWindow:show()
  lootList = {}
  
  local tables = buffer:explode("|")
  local collectAll = tables[1]:explode("*")
  if collectAll[1] == "yes" then
     lootWindow:getChildById('getAll'):setChecked(true)
  end
  
	lootWindow:show()
end