local SUIView = class("SUIView",function (args) 
	return vv.newEventNode()
end)



function SUIView:ctor() 
	local taskList = display.newColorLayer(ccc4(0,0,0,200)):size(250,210):pos(0,display.cy):addTo(self)
	cc.ui.UILabel.new({text = "任务列表", size = 20, color = display.COLOR_WHITE}):addTo(taskList):pos(0,200)
	self._list = vv.newList({data=Cache.taskList,nodeSize={250,52},size=cc.size(250,180)}):addTo(self):pos(0,display.cy)
end

return SUIView