

local SkillBar = import(".components.SkillBar")
local NavBar   = import(".components.NavBar")
local Tips 	   = import(".components.Tips")
local MainUIView = class("MainUIView",function () 
	return display.newNode()
end)


function MainUIView:ctor()
	vv.newJoyStick():addTo(self):pos(150,120)
	SkillBar.new({call1={function()
		print("1")
		end}}):addTo(self)

	NavBar.new():addTo(self)

	self._tips = Tips.new():addTo(self)
end



return MainUIView