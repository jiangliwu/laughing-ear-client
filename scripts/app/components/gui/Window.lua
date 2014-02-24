
local DEFAULT_WINDOW_SIZE = {width=400,height=400}

local Window = class("Window",function (args)
	local windowSize = args.size or cc.size(DEFAULT_WINDOW_SIZE.width,DEFAULT_WINDOW_SIZE.height)
	return display.newScale9Sprite("window.png",0,0,windowSize)
end)


--[[
full
size
close
closeCallBack
tip
layer
dontclose
bodyEvent
]]

function Window:ctor(args) 
	
	self._isTip = args.tip
	self._full = args.full or args.tip
	self._bodyEvent = args.bodyEvent

	self:registerScriptHandler(function(event) 
		if ( event == "enter") then
			self:onEnter()
		elseif ( event == "exit") then
			self:onExit()
		end
	end)

	if not args.layer then LayerManager.layers['window']:addChild(self)  else args.layer:addChild(self) end

	if args.close == false then 
		return nil
	end
	
	local size = args.size or DEFAULT_WINDOW_SIZE
	cc.ui.UIPushButton.new("close.png")
        :onButtonPressed(function(event)
            transition.scaleTo(event.target,{time=0.05,scale=1.05})
        end)
        :onButtonRelease(function(event)
            transition.scaleTo(event.target,{time=0.05,scale=1.00})
        end)
        :onButtonClicked(function(event)
        	if args.closeCallBack then
        		args.closeCallBack()
        	end
        	if args.dontclose == true then print("dont close window !") else self:removeSelf() end
        end)
        :pos(size.width -10,size.height -10)
        :addTo(self)

               
end


function Window:onExit () 
	self:removeTouchEventListener()
end

function Window:pos(x,y) 
	--[[

	]]

	local cs = self:getContentSize()
	if cs.height/2 + y >= display.height then  y = display.height - cs.height/2 - 10 end
	if y - cs.height/2 <= 0 then  y = cs.height/2 end
	if cs.width/2 + x >= display.width then  x = display.width - cs.width/2 - 10 end
	if x - cs.width/2  <= 0 then  x = cs.width/2 end

	return Window.super.pos(self,x,y)
end

function Window:onEnter()

	self:setTouchEnabled(true)
	
	if self._full == true then
		local tx,ty = self:getPosition()
		self:setCascadeBoundingBox(cc.rect(-display.right,-display.top,2*display.right,2*display.top))
	end

    self:addTouchEventListener(function(event, x, y, prevX, prevY)

        if event == "began" then
        	print("-------------window------------  you click window body !")
        	if self._bodyEvent then self._bodyEvent() end
            return true
        end

        if event == "moved" then

        elseif event == "ended" then
        	if self._isTip == true then
        		self:removeSelf()
        	end
        end
    end, cc.MULTI_TOUCHES_ON)

end

function Window:anch(x,y) 
	self:setAnchorPoint(ccp(x,y))
	return self
end

function Window:pos (x,y) 
	self:setPosition(ccp(x,y))
	return self
end


return Window

