local DestRoleView = class("DestRoleView",function(args) 
	return vv.newEventNode()
end)


function DestRoleView:ctor() 


	--self._head = display.newSprite("head.png"):addTo(self)


	local function getProgress ( bg , content , per) 
    	local p = CCProgressTimer:create(content)
    	p:setAnchorPoint(ccp(0,0))
    	p:setPosition(ccp(6,10))
	    p:setType(kCCProgressTimerTypeBar)
	    p:setMidpoint(CCPointMake(0, 0))
	    p:setBarChangeRate(CCPointMake(1, 0))
	    p:setPercentage(per)
	    bg:addChild(p)
	    return p
    end
    self._name =  ui.newTTFLabel({text = "我是蜘蛛", size = 20, 
    	color=ccc3(255,255,0)})
        :pos(120, 30)
        :addTo(self)
    self._health  = getProgress(display.newSprite("pro_bg.png"):addTo(self):pos(120,5),display.newSprite("pro_m.png"),100) 
    --self._mana = getProgress(display.newSprite("pro_bg.png"):addTo(self):pos(120,-25),display.newSprite("pro_m.png"),60)

    self:hide()
end


function DestRoleView:update(args) 
	if not args then self:hide() return nil end
	self._name:setString(args.name..args.id)
	self._health:setPercentage(args.now/args.blood*100)
	self:show()
end

return DestRoleView