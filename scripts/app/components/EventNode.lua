local EventNode = class("EventNode",function () 
	return display.newNode()
end)

function EventNode:ctor() 
	--require("framework.api.EventProtocol").extend(self)

	self:registerScriptHandler(function(event) 
		if ( event == "enter") then
			self:onEnter()
		elseif ( event == "exit") then
			self:onExit()
		end
	end)
end

return EventNode