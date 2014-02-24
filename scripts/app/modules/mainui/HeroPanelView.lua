
local Package = import(".components.Package")

local HeroPanelView = class("HeroPanelView",function () 
	return display.newNode()
end)



function HeroPanelView:ctor() 

    self._package = Package.new()
    self._heroPanel = vv.newWindow({
                full = true,
                close = true,
                closeCallBack = function () self._heroPanel:setVisible(false) end , 
                size = cc.size(900,500),
                dontclose = true,
                }):pos(display.cx,display.cy)

    self._heroPanel:addChild(self._package)
    self._heroPanel:setVisible(false)



	self._head = display.newSprite("head.png")
		:pos(50,display.top-60)
		:addTo(self)

	self._head:setTouchEnabled(true)
    self._head:addTouchEventListener(function(event, x, y, prevX, prevY)
        if event == "began" then
            return true
        end
        if event == "moved" then
        elseif event == "ended" then
            self._heroPanel:setVisible(true)
        end
    end, cc.MULTI_TOUCHES_ON)



    ui.newTTFLabel({text = "背包", size = 32, 
        align = ui.TEXT_ALIGN_CENTER,
        color=ccc3(255,255,0)})
        :pos(420,380)
        :addTo(self._heroPanel)

    self._name = ui.newTTFLabel({text = "请叫我陈大 LVL:30", size = 20, 
    	color=ccc3(255,255,0)})
        :pos(180, display.top-20)
        :addTo(self)


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

    
    self._exp = getProgress(display.newSprite("exp_bg.png"):addTo(self):pos(display.cx,0),display.newSprite("exp_m.png"),60)
    self._health  = getProgress(display.newSprite("pro_bg.png"):addTo(self):pos(180,display.top-50),display.newSprite("pro_m.png"),80) 
    self._mana = getProgress(display.newSprite("pro_bg.png"):addTo(self):pos(180,display.top-80),display.newSprite("pro_m.png"),60)
    
end

return HeroPanelView