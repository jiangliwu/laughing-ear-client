
local NAV_BAR_NUMBER = 6

local NavBar = class("NavBar",function () 
	return display.newNode()
end)



function NavBar:ctor() 

	for i=1,NAV_BAR_NUMBER do
		vv.newButton("joy_cen.png",function() printf("---- nav" , i) end)
		:addTo(self)
		:pos(i*120 + 75 ,-35)
	end

end


return NavBar