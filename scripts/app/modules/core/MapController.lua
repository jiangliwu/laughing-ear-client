local MapView = import(".MapView")


local MapController = class("MapController",function()
	return vv.newEventNode()
end)


function MapController:ctor() 


	self.__view = MapView.new():addTo(self)
	self._npc = {}
	self._monster = {}
	self._mapId = 0;

	LEvent.addLEvent(LEvent.HERO_MOVE,function(args)
		--print("################################dispatchLEvent " .. args.name..args.x..args.y)
	end)

	LEvent.addLEvent(LEvent.TASK_UPDATE , function(args) 
		self._npc[args.id]:updateTask(args)
	end)
	
	LEvent.addLEvent(LEvent.NPC_INIT,function (args) 
		for i=1,#args do
			self._npc[args[i].id] = self.__view:addNpc(args[i])
		end
		LEvent.dispatchLEvent(LEvent.WEB_SOCKET_SEND,json.encode({method="npc_updateTask",args={"null"}}))
		--LEvent.dispatchLEvent(LEvent.TASK_UPDATE)
	end)

	LEvent.addLEvent(LEvent.MONSTER_INIT, function (args) 
		for i = 1, #args do
			self._monster[args[i].id] = self.__view:addMonster(args[i])
		end
	end)
	
	LEvent.addLEvent(LEvent.MAP_LOAD, function (a)
		print("Load Event~~~~~~~~~~~~~~~~~~~~~~~~~")
		self.__view:loadMap(a.id)
		self._mapId = a.id 
		LEvent.dispatchLEvent(LEvent.WEB_SOCKET_SEND,json.encode({method="npc_getNpcByMap",args={a.id}}))

		LEvent.dispatchLEvent(LEvent.MONSTER_INIT,{
		{id=1,name="spider",blood=120,now=120,x=11,y=13},
		{id=2,name="spider",blood=120,now=100,x=12,y=13},
		{id=3,name="spider",blood=120,now=120,x=13,y=13},
		{id=4,name="spider",blood=120,now=120,x=14,y=14},
		{id=5,name="spider",blood=120,now=120,x=15,y=14},
		{id=6,name="spider",blood=120,now=120,x=16,y=16}
		})
	end)
	
	LEvent.addLEvent(LEvent.HERO_LOAD,function(args)
		self.__view:heroLoad(args.posx,args.posy)
	end)

	LEvent.addLEvent(LEvent.GET_HERO,function(args) 
		return self.__view._hero
	end)

	LEvent.addLEvent(LEvent.GET_MONSTER,function(args) 
		return self._monster[args.id]
	end)

end

function MapController:onEnter()
	print(" ----- MapController onEnter ---------")
end

function MapController:onExit() 
	print(" ----- MapController onExit ---------")

	LEvent.removeLEvent(LEvent.HERO_MOVE)
	LEvent.removeLEvent(LEvent.NPC_INIT)
	LEvent.removeLEvent(LEvent.TASK_UPDATE)
	LEvent.removeLEvent(LEvent.MAP_LOAD)
	LEvent.removeLEvent(LEvent.HERO_LOAD)
end


return MapController