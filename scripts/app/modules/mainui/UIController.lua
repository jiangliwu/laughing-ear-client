local HeroPanelView = import(".HeroPanelView")
local MainUIView = import(".MainUIView")
local ActivityBar = import(".components.ActivityBar")
local SUIView = import(".SUIView")
local DestRoleView = import(".DestRoleView")


local UIController = class("UIController",function ( )  
	return vv.newEventNode()
end)


function UIController:ctor ()
	self.__heroPanelView = HeroPanelView.new():addTo(self)
	self.__mainUIView = MainUIView.new():addTo(self):pos(0,-10)
	self.__sUIView = SUIView.new():addTo(self)
	self.__destRoleView = DestRoleView.new():addTo(self):pos(380,display.top-55)
	

	ActivityBar.new():addTo(self)

	LEvent.addLEvent(LEvent.TASK_LIST_RELOAD,function() 
		self.__sUIView._list:reloadList(Cache.taskList)
	end)

	LEvent.addLEvent(LEvent.PACKAGE_UPDATE,function(args) 
		
	end)

	LEvent.addLEvent(LEvent.ITEM_DELETE,function(args)
		if not args.index or args.index > 240 then return nil end
		Cache.packageData[args.index] = 0
		self.__heroPanelView._package:updatePackNodeByIndex(args.index)
	end)


	LEvent.addLEvent(LEvent.ITEM_EQUIP,function(args) 
		
	end)

	LEvent.addLEvent(LEvent.ITEM_SELL,function(args) 
		
	end)

	LEvent.addLEvent(LEvent.ITEM_BUY,function(args) 
		
	end)

	LEvent.addLEvent(LEvent.UPDATE_DEST , function (args) 
		self.__destRoleView:update(args)
	end)

	LEvent.addLEvent(LEvent.NEW_TIP,function(args)
		self.__mainUIView._tips:addTip(args)
	end)
end

function UIController:onExit()
	LEvent.removeLEvent(LEvent.ITEM_DELETE)
	LEvent.removeLEvent(LEvent.ITEM_BUY)
	LEvent.removeLEvent(LEvent.ITEM_SELL)
	LEvent.removeLEvent(LEvent.ITEM_EQUIP)
end

function UIController:onEnter()

end

return UIController