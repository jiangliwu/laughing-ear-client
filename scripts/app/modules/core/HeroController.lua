local HeroController = class("HeroController",function() return vv.newEventNode() end)

function HeroController:ctor() 
	self._dest = nil

	LEvent.addLEvent(LEvent.CHANGE_DEST,function(args)

		if args and args.id == self._dest then 
			return true
		end

		LEvent.dispatchLEvent(LEvent.UPDATE_DEST,args)
		if args then self._dest = args.id else self._dest = nil end

		return false
	end)

	self._hero = LEvent.dispatchLEvent(LEvent.GET_HERO)

	LEvent.addLEvent(LEvent.HERO_ATTACK,function(args) 

		
		if self._dest == nil then 
			LEvent.dispatchLEvent(LEvent.NEW_TIP,{msg="没有选中目标。"})
			return nil
		end


		self._hero:playAttackAction(LEvent.dispatchLEvent(LEvent.GET_MONSTER,{id=self._dest}))

	end)

end


function HeroController:onExit()
	LEvent.removeLEvent(LEvent.CHANGE_DEST)
end


function HeroController:onEnter() 

end



return HeroController