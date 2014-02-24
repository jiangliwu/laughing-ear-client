local Role = import(".Role")


local Hero = class("Hero",Role)

function Hero:ctor(args)
	if not args then args = {} end
	args.file = "hero.png"
	args.name = "hero"
	Hero.super.ctor(self,args)


	self:setAnimationDelay(0.08)
end



function Hero:onEnter() 
	Hero.super.onEnter(self)
end


function Hero:onExit() 
	Hero.super.onExit(self)
end

return Hero