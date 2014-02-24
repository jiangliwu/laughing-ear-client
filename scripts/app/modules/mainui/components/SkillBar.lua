

local SKILL_BAR_NUMBER = 5
local SKILL_ROLL = 4

local SkillBar = class("SkillBar",function (args) 
	return display.newNode()
end)

--[[

call1
call2

]]


function SkillBar:ctor (args) 


	

	for i = 1,SKILL_BAR_NUMBER do
		local callback = nil
		if args.call1 then
			callback = args.call1[i]
		end

		vv.newButton("skill.png",callback)
        :pos(i*80 + 250 ,80)
        :addTo(self)
        :setButtonLabel(cc.ui.UILabel.new({text = i, size = 20, color = display.COLOR_BLUE}))
	end 

	for i=1,SKILL_ROLL do
		local callback = nil
		if args.call1 then
			callback = args.call1[i]
		end
		local cx,cy = display.width-80,80

		if i == 1 then
			vv.newButton("joy_cen.png",function() 
					LEvent.dispatchLEvent(LEvent.HERO_ATTACK,{skill=1})
				end):pos(cx,cy):addTo(self):setButtonLabel(cc.ui.UILabel.new({text = "攻击", size = 16, color = display.COLOR_BLUE}))
		else
			local function getPos(angle , radius , cx, cy) 
				angle = angle*math.pi/180
				return math.sin(angle)*radius + cx, math.cos(angle)*radius + cy
			end
			vv.newButton("skill.png"):pos(getPos( 155 + i*50, 100 , cx,cy)):addTo(self)
			:setButtonLabel(cc.ui.UILabel.new({text = i, size = 20, color = display.COLOR_BLUE}))
		end
	end

end

function SkillBar:reloadSkill( ) 

end

return SkillBar