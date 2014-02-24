local Tips = class("Tips",function() return display.newNode() end)

local TIP_MAX_COUNT = 5
local DEFAULT_MSG   = "未定义消息!!!!"

function Tips:ctor() 

	self._ll = {}
	self._tipsNumber = 1

	for i= 1,TIP_MAX_COUNT do
		self._ll[i] = cc.ui.UILabel.new({text = DEFAULT_MSG, size = 18, color = display.COLOR_WHITE}):pos(display.cx,display.top-50-i*20):addTo(self)
		self._ll[i]:hide()
	end
end


function Tips:addTip(args) 
	self._ll[self._tipsNumber]:setString(args.msg or DEFAULT_MSG)
	self:_showTip()
end


function Tips:_showTip()
	self._ll[self._tipsNumber]:show()
	transition.fadeOut(self._ll[self._tipsNumber],{time=0.5})
	self._tipsNumber = self._tipsNumber + 1
	if self._tipsNumber > TIP_MAX_COUNT then self._tipsNumber = 1 end
end

return Tips