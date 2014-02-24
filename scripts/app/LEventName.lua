__eventNumber  = 1
local function getEventID () 
	local id = __eventNumber
	__eventNumber = __eventNumber + 1
	return id
end


LEvent.HERO_MOVE 			= getEventID()
LEvent.HERO_DONE 			= getEventID()
LEvent.WEB_SOCKET_OPEN 		= getEventID()
LEvent.WEB_SOCKET_CLOSE 	= getEventID()
LEvent.WEB_SOCKET_ERROR 	= getEventID()
LEvent.WEB_SOCKET_MESSAGE 	= getEventID()
LEvent.WEB_SOCKET_SEND 		= getEventID()
LEvent.NPC_INIT 			= getEventID()
LEvent.MAP_LOAD 			= getEventID()
LEvent.TASK_LIST_RELOAD		= getEventID()
LEvent.TASK_UPDATE	        = getEventID()
LEvent.LOGIN_FAIL			= getEventID()
LEvent.LOGIN_SUCCESS		= getEventID()
LEvent.HERO_LOAD			= getEventID()

LEvent.PACKAGE_UPDATE		= getEventID()
LEvent.ITEM_DELETE			= getEventID()
LEvent.ITEM_EQUIP			= getEventID()
LEvent.ITEM_SELL			= getEventID()
LEvent.ITEM_BUY				= getEventID()
LEvent.MONSTER_INIT	    	= getEventID()
LEvent.CHANGE_DEST			= getEventID()
LEvent.UPDATE_DEST			= getEventID()
LEvent.GET_HERO				= getEventID()
LEvent.HERO_ATTACK			= getEventID()
LEvent.NEW_TIP				= getEventID()
LEvent.GET_MONSTER			= getEventID()