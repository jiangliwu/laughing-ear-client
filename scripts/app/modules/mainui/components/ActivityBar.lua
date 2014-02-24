local ActivityBar = class("ActivityBar",function() 
	return display.newNode()
end)


function ActivityBar:ctor( )

	vv.newButton("joy_cen.png",function() end)
	:pos(display.right-100,display.top-50)
	:addTo(self)
	:setButtonLabel(cc.ui.UILabel.new({text = "商城", size = 16, color = display.COLOR_BLUE}))

	vv.newButton("joy_cen.png",function() end)
	:pos(display.right-200,display.top-50)
	:addTo(self)
	:setButtonLabel(cc.ui.UILabel.new({text = "首冲大礼包", size = 16, color = display.COLOR_BLUE}))

	vv.newButton("joy_cen.png",function() end)
	:pos(display.right-300,display.top-50)
	:addTo(self)
	:setButtonLabel(cc.ui.UILabel.new({text = "战场", size = 16, color = display.COLOR_BLUE}))
end

return ActivityBar