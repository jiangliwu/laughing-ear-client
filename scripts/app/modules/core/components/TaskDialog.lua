--[[
full
size
close
closeCallBack
tip

yes
no

title
content

]]

local TaskDialog = class("TaskDialog",function (args) 
	return vv.newWindow(args)
end)


function TaskDialog:ctor (args)


	if args.yes then
		vv.newButton("button.png",function()  args.yes() self:removeSelf() end)
		:setButtonLabel(cc.ui.UILabel.new({text = args.yname or "确认", size = 24, color = display.COLOR_BLUE}))
		:pos(args.size.width - 100,50):addTo(self)
	end

	if args.no then
		vv.newButton("button.png",function()  args.no() self:removeSelf() end)
		:setButtonLabel(cc.ui.UILabel.new({text = args.nname or "取消", size = 24, color = display.COLOR_BLUE}))
		:pos(100,50):addTo(self)
	end

	local title   = args.title or ""
	local content = args.content  or "args.content"

	self._title =  cc.ui.UILabel.new({text = title, size = 24, color = display.COLOR_WHITE , dimensions = cc.size(args.size.width-10,48)}):addTo(self):pos( 10,args.size.height-100)
	self._content = cc.ui.UILabel.new({text = content, size = 18, color = display.COLOR_WHITE ,  dimensions = cc.size(args.size.width-10,48) }):addTo(self):pos(10,args.size.height/2)
end

function TaskDialog:updateMsg(title,content) 
	self._title:setString(title)
	self._content:setString(content)
end

function TaskDialog:onEnter() 
	print("on")
end


return TaskDialog