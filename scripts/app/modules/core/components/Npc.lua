local TaskDialog = import(".TaskDialog")
local Role = import(".Role")

local Npc = class("Npc",Role)


function Npc:ctor(args)
	--self:addCall(handler(self,self.openDialog))
	Npc.super.ctor(self,{file="npc.png",name="npc"..args.id,cols=6})
	self._id = args.id or 0
	self._msg  = args.message
	self._walkSize = args.walkSize
	self._walkPath = {{0,1},{0,-1}}


	cc.ui.UILabel.new({text = args.name, size = 18, color = display.COLOR_WHITE}):addTo(self):pos(0,80)
	self._task = nil

	self:registerClick(handler(self,self.openDialog))
	self:setAnimationDelay(0.15)
end

function Npc:updateTask(args) 
	if self._task then self._task = nil end
	self._task = args

end


function Npc:openDialog ()

	if self._task == nil then 
		
		local dialog = TaskDialog.new({
		full	= true,
		size = cc.size(300,250),
		content = self._msg[vv.getRandomInt(1,#self._msg)],
		bodyEvent = function() print("update content") end,
		}):pos(display.cx,display.cy)

		return nil
	end

	local window = TaskDialog.new({
		full	= true,size=cc.size(350,250),
		yname   =  "接受任务",
		nname   =  "取消任务",
		yes 	= function() print("提交任务") end,
		no  	= function() print("取消任务") end,
		title 	= self._task.title,
		content = self._task.content
		}):pos(display.cx,display.cy)
end

function Npc:startWalk(n) 
	if(n > 2) then n = 1 end

	local posx,posy = self:getPosition()
	if self._walkPath[n][2] == -1 then self:right() else self:up() end

	self:runAction(CCSequence:createWithTwoActions(
				CCMoveTo:create(1.05,ccp(posx+self._walkPath[n][1]*self._walkSize.width,posy+self._walkSize.height*self._walkPath[n][2])),
				CCCallFunc:create(function() self:startWalk(n+1) end)
				))
end

function Npc:startAI() 
	self:startWalk(1)
	return self
end

function Npc:onEnter() 
	Npc.super.onEnter(self)

	--self:startWalk(1)
end

function Npc:onExit() 


	Npc.super.onExit(self)
end

return Npc