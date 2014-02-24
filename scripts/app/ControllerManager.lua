require('app.LayerManager')
require('app.components.vv')
require('app.components.LEvent')
require('app.Cache')

local MapController = import(".modules.core.MapController")
local UIController  = import(".modules.mainui.UIController")
local HeroController = import(".modules.core.HeroController")

local LEVENT_SIZE = 1024

local WebSockets = import(".net.WebSockets")

ControllerManager = {
	root = nil,
	controllers = {}
}

function ControllerManager.init( root )
	LayerManager.init(root)
	LEvent.init(LEVENT_SIZE)

	local netConnect = cc.ui.UILabel.new({text = "网络连接中....", size = 36, color = display.COLOR_RED})
	:addTo(LayerManager.root)
	:pos(display.cx,display.cy)


	local net = WebSockets.new("ws://127.0.0.1:3387")

	LEvent.addLEvent(LEvent.LOGIN_SUCCESS , function (args)

		netConnect:removeSelf()
		ControllerManager.controllers['map']=MapController.new()
		LayerManager.layers['map']:addChild(ControllerManager.controllers['map'])
		ControllerManager.controllers['ui'] = UIController.new()
		LayerManager.layers['ui']:addChild(ControllerManager.controllers['ui'])

		
		LEvent.dispatchLEvent(LEvent.MAP_LOAD,{id=args.map})			-- init map
		LEvent.dispatchLEvent(LEvent.HERO_LOAD,{posx=args.posx,posy=args.posy})		-- init hero

		ControllerManager.controllers['hero'] = HeroController.new()			-- only controller , no view
		LayerManager.layers['ui']:addChild(ControllerManager.controllers['hero'])

	end)
	
	LEvent.addLEvent(LEvent.LOGIN_FAIL , function (args) 
		netConnect:setString("用户名或者密码错误!!!!")
	end)

	LEvent.addLEvent(LEvent.WEB_SOCKET_CLOSE, function () 
		print("################################## LEvent WEB_SOCKET_CLOSE")
		netConnect:setString("网络连接失败.....")
	end)
	LEvent.addLEvent(LEvent.WEB_SOCKET_ERROR, function () 
		print("#################################### LEvent WEB_SOCKET_ERROR")
		netConnect:setString("网络连接错误.....")
	end)

	LEvent.addLEvent(LEvent.WEB_SOCKET_OPEN, function () 
		print("####################################  connect success !")
		netConnect:setString("使用默认账户登陆中!")
		net:send(json.encode({method="user_login",args={"vv-jiangliwu1","100200"}}))
	end)


	LEvent.addLEvent(LEvent.WEB_SOCKET_MESSAGE, function (args)
		print(args.message)
		local command = json.decode(args.message)
		if command == nil then return nil end
		LEvent.dispatchLEvent(loadstring("return LEvent."..command.method)(),command.args)
	end)

	LEvent.addLEvent(LEvent.WEB_SOCKET_SEND,function(args)
		net:send(args,WebSockets.TEXT_MESSAGE)
	end)


end