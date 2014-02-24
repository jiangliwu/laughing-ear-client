local Role    = import(".Role")
local Monster = class("Monster",Role)


function Monster:ctor(args) 
	Monster.super.ctor(self,{file=args.name..".png",name=args.name..args.id,cols=4})

	self._args = args
	self._walkSize = args.walkSize
	self._walkPath = {{0,1},{0,-1}}
	self._aniName = args.name..args.id
	self:registerClick(function() self:onTap() end)

	cc.ui.UILabel.new({text = args.name, size = 18, color = display.COLOR_WHITE}):addTo(self):pos(0,50)
end


function Monster:onTap() 
	print("*************************you click Monster "..self._aniName)
	local ret = LEvent.dispatchLEvent(LEvent.CHANGE_DEST,self._args)
	if ret == true then 
		print("attck !")
	end
end


function Monster:startWalk(n) 
	if(n > 2) then n = 1 end

	local posx,posy = self:getPosition()
	self:left()
	self:getSprite():runAction(CCRepeatForever:create(CCAnimate:create(display.getAnimationCache(self._aniName..1))))
end

function Monster:startAI() 
	self:startWalk(1)
	return self
end

return Monster
