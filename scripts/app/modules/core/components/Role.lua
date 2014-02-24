local Role = class("Role",function(args) 
	return vv.newEventNode()
end)


function Role:ctor(args) 
	self._rows = args.rows or 4
	self._cols = args.cols or 8
	self._name = args.name

	self._texture = CCTextureCache:sharedTextureCache():addImage(args.file)
	self._sw      = self._texture:getContentSize().width/self._cols
	self._sh	  = self._texture:getContentSize().height/self._rows

	self._upAni , self._upSpr = self:_getAnimationAndSprite(3)
	self._leftAni , self._leftSpr = self:_getAnimationAndSprite(1)
	self._rightAni , self._rightSpr = self:_getAnimationAndSprite(2)
	self._downAni , self._downSpr = self:_getAnimationAndSprite(4)

	self:addChild(self._rightSpr)
	self:addChild(self._leftSpr)
	self:addChild(self._upSpr)
	self:addChild(self._downSpr)
	self:_hideSpr()
	self:_showSpr(self._rightSpr)

	self._clickCall = nil

	self:_createAttackAnimate()

end


function Role:registerClick( fun ) 
	self._clickCall = fun
end

function Role:up() 
	self:_showSpr(self._upSpr)
	self._upSpr:runAction(CCAnimate:create(display.getAnimationCache(self._name..3)))
end
function Role:down() 
	self:_showSpr(self._downSpr)
	self._downSpr:runAction(CCAnimate:create(display.getAnimationCache(self._name..4)))
end
function Role:left() 
	self:_showSpr(self._leftSpr)
	self._leftSpr:runAction(CCAnimate:create(display.getAnimationCache(self._name..1)))
end
function Role:right() 
	self:_showSpr(self._rightSpr)
	self._rightSpr:runAction(CCAnimate:create(display.getAnimationCache(self._name..2)))
end

function Role:getSprite() 
	if self._upSpr:isVisible() then return self._upSpr end
	if self._downSpr:isVisible() then return self._downSpr end
	if self._leftSpr:isVisible() then return self._leftSpr end
	if self._rightSpr:isVisible() then return self._rightSpr end
	return nil
end

function Role:playAction(x,y) 
	if x == -1 then self:left() return nil end
	if x == 1 then self:right() return nil end
	if y == -1 then self:up() return nil end
	if y == 1 then self:down() return nil end
end

function Role:_hideSpr() 
	self._upSpr:setVisible(false)
	self._downSpr:setVisible(false)
	self._leftSpr:setVisible(false)
	self._rightSpr:setVisible(false)
end

function Role:_showSpr(node)
	self:_hideSpr()
	self._dir = node.dir
	node:setVisible(true)
end

function Role:setAnimationDelay(time) 
	display.getAnimationCache(self._name..1):setDelayPerUnit(time)
	display.getAnimationCache(self._name..2):setDelayPerUnit(time)
	display.getAnimationCache(self._name..3):setDelayPerUnit(time)
	display.getAnimationCache(self._name..4):setDelayPerUnit(time)
end


function Role:_getAnimationAndSprite ( n) 
	--local frames = 
	local frames = {}
	for i = 1,self._cols do
		frames[i] = CCSpriteFrame:createWithTexture(self._texture,cc.rect(
			(i-1)*self._sw,(n-1)*self._sh,self._sw,self._sh))
	end
	frames[#frames+1] = frames[1]

	local ani = display.newAnimation(frames,0.06)
	display.setAnimationCache(self._name..n,ani)
	local spr = CCSprite:createWithSpriteFrame(frames[1])
	spr.dir = n
	spr:setAnchorPoint(ccp(0.5,0.3))
	return ani,spr
end

function Role:playAttackAction(dest)
	print("you play ".. self._dir.. " action")
	print(self._name.."attack"..self._dir)
	self:getSprite():runAction(CCAnimate:create(display.getAnimationCache(self._name.."attack"..self._dir)))

	if ( self._name )
	print(dest:convertToWorldSpace(cc.p(0,0)).x)

end

function Role:_createAttackAnimate()

	if self._name == "hero" then 
		local t = CCTextureCache:sharedTextureCache():addImage("hero_a.png")
		local w = t:getContentSize().width/5
		local h = t:getContentSize().height/4

		local frames = {}
		for i = 1,8 do
			local a = 0
			if i%5 == 0 then a = 5 else a = i%5 end 
			local b = 0
			if i%5 == 0 then b = i/5-1 else b = math.floor(i/5) end 

			frames[i] = CCSpriteFrame:createWithTexture(t,cc.rect(
			(a-1)*w,b*h,w,h/2))
		end
		frames[#frames+1] = frames[1]

		print(self._name.."attack1")
		display.setAnimationCache(self._name.."attack1",display.newAnimation(frames,0.1))
		display.setAnimationCache(self._name.."attack3",display.newAnimation(frames,0.1))

		frames = {}
		for i=9,16 do
			if i%5 == 0 then a = 5 else a = i%5 end 
			local b = 0
			if i%5 == 0 then b = i/5-1 else b = math.floor(i/5) end 
			frames[i-8] = CCSpriteFrame:createWithTexture(t,cc.rect(
			(a-1)*w,b*h,w,h/2))
		end
		
		frames[#frames+1] = frames[1]
		display.setAnimationCache(self._name.."attack2",display.newAnimation(frames,0.1))
		display.setAnimationCache(self._name.."attack4",display.newAnimation(frames,0.1))
	end
end


function Role:onEnter() 
	print("*****************Role onEnter")

	self:setTouchEnabled(true)
    self:addTouchEventListener(function(event, x, y, prevX, prevY)
        if event == "began" then
        	if not self._clickCall then return false end
            return true
        end

        if event == "moved" then

        elseif event == "ended" then
        	self._clickCall()
        end
    end, cc.MULTI_TOUCHES_ON)
end

function Role:onExit() 
	print("***************** Role onExit")
end

return Role