local JoyStick = class("JoyStick",function(args) 
	return display.newSprite("joy_bg.png")
end)


function JoyStick:ctor (args) 

	local size = self:getContentSize()
	display.newSprite("joy_cen.png"):addTo(self):pos(size.width/2,size.height/2)

	self:registerScriptHandler(function(event) 
		if ( event == "enter") then
			self:onEnter()
		elseif ( event == "exit") then
			self:onExit()
		end
	end)

end



function JoyStick:onExit () 
	self:removeTouchEventListener()
end


function JoyStick:onEnter()

	self:setTouchEnabled(true)
    self:addTouchEventListener(function(event, x, y, prevX, prevY)

        if event == "began" then
            return true
        end

        if event == "moved" then

        elseif event == "ended" then
        	print("your click JoyStick!")
        end
    end, cc.MULTI_TOUCHES_ON)

end


return JoyStick