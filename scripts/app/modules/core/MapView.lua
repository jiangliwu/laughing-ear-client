local Map = import("...components.map.Map")
local Npc = import(".components.Npc")
local Hero = import(".components.Hero")
local Monster = import(".components.Monster")


local MapView = class("MapView", function()
    return vv.newEventNode()
end)



function MapView:ctor ()
	print("-------------------------MapView init !")

	self._map = nil
	self._hero = nil

	self._dest = {0,0}
	self._pathHead = nil

	self:registerScriptHandler(function(event) 
		if ( event == "enter") then
			self:onEnter()
		elseif ( event == "exit") then
			self:onExit()
		end
	end)

end


function MapView:loadMap(mapid) 
	if self._map then
		self._map:removeFromParent(true)
		self._map = nil
	end
	self._map = Map.new(mapid..".tmx")
	self:addChild(self._map)
end

function MapView:heroLoad(posx,posy) 
	if self._hero then self._hero:removeFromParent(true) end
	self._hero = Hero.new():pos(self._map:tileToWorldPos(posx,posy)):addTo(self)
end

function MapView:addNpc(args) 
	args.walkSize = self._map:getTileSize()
	return Npc.new(args):addTo(self._map):pos(self._map:tileToPos(args.pos[1],args.pos[2])):startAI()
end


function MapView:addMonster(args) 
	args.walkSize = self._map:getTileSize()
	return Monster.new(args):addTo(self._map):pos(self._map:tileToPos(args.x,args.y)):startAI()
end

function MapView:_dirIsRight(sx,sy,ex,ey,mx,my) 
	if (mx - sx)*(ex - sx) >= 0 and (my - sy)*(ey - sy) >= 0 then
		return true
	end
	return false
end

function MapView:_getTArray( nx , ny , value ) 

	local ret = {}
	for i = 1,nx do
		ret[i] = {}
		for j = 1 , ny do
			ret[i][j] = value
		end
	end
	return ret
end

function MapView:_getPathByBfs(sx,sy,ex,ey) 
	local g 		= self:_getTArray(31,21,false)
	local visited 	= self:_getTArray(31,21,false)


	--printf("-------------------------------------Start find Path %d %d -> %d %d",sx,sy,ex,ey)
	local queue = {}
	local queue_first = 0
	local queue_last = 0
	local dir = {0,1,0,-1,1,0,-1,0,1,1,1,-1,-1,1,-1,-1}

	local function queue_push ( obj )
		visited[obj[1]+1][obj[2]+1] = true
		queue[queue_first] = obj
		queue_first = queue_first - 1
	end

	local function queue_pop( obj )
		local ret = queue[queue_last]
		queue_last = queue_last - 1
		return ret
	end

	queue_push({sx,sy})
	repeat
		local tmp = queue_pop()
		if tmp[1] == ex and tmp[2] == ey then
			--print("---------------------------success get Dest path !")
			break
		end

		for i = 1 , 8 do
			local nextx = tmp[1] + dir[2*i-1]
			local nexty = tmp[2] + dir[2*i]

			if self._map:isPointInSide(nextx,nexty) 
				and visited[nextx+1][nexty+1]  == false 
				and self:_dirIsRight(sx,sy,ex,ey,nextx,nexty) == true
				and self._map:layerNamed("Tile Layer 1"):tileGIDAt(ccp(nextx,nexty)) ~= 1
				then
				g[nextx+1][nexty+1] = {tmp[1]+1,tmp[2]+1}
				queue_push({nextx,nexty})
			end
		end
	until queue_first == queue_last

	
	local tx,ty = ex+1,ey+1
	self._pathHead = {next=nil,pre=nil,value={tx-1,ty-1}}
	repeat
		local nexta = g[tx][ty]
		tx = nexta[1]
		ty = nexta[2]
		self._pathHead.pre = {next=self._pathHead,pre=nil,value={tx-1,ty-1}}
		self._pathHead = self._pathHead.pre;
	until g[tx][ty] == false

	self._pathHead = self._pathHead.next
end

function MapView:_heroMove( posx, posy )

	-- clear dest
	LEvent.dispatchLEvent(LEvent.CHANGE_DEST,nil)
	
	local sx,sy = self._map:worldToTile(self._hero:getPosition())
	local ex,ey = self._map:worldToTile(posx,posy)
	self._pathHead = nil

	if sx == ex and sy == ey or self._map:layerNamed("Tile Layer 1"):tileGIDAt(ccp(ex,ey)) == 1 then
		return nil
	end

	self._dest = {ex,ey}
	self:_getPathByBfs(sx,sy,ex,ey)
	if not self._adjusting then
		self:_adjustMapByHero()
	end
end


function MapView:_adjustMapByHero()

	if self._pathHead == nil then
		self._adjusting = nil
		return nil
	end

	self._adjusting = true

	local destPos  = self._pathHead.value
	local wx,wy = self._map:tileToWorldPos(destPos[1],destPos[2])
	local hx,hy = self._hero:getPosition()
	local mx,my = self._map:getPosition()
	local offx,offy = wx -hx, wy - hy

	local dx,dy = self._map:worldToTile(wx,wy,false)
	local fx,fy = self._map:worldToTile(hx,hy,false)
	local moveTime = 0.72 
	self._pathHead = self._pathHead.next

	if self._map:isScreenInSide(mx-offx,my-offy) then
		
		local MIDX ,MIDY= 8,16
		local function isHeroMove ( dx ,dy , fx, fy) 
			if fx == MIDX and fy == MIDY then
				return false
			end

			if dx - fx  > 0 and dx < MIDX then
				return true
			elseif dx - fx < 0 and dx > MIDX then
				return true
			end

			if dy - fy  > 0 and dy < MIDY then
				return true
			elseif dy - fy < 0 and dy > MIDY then
				return true
			end

			return false
		end
		
		-- 如果地图可以移动，检测人物是否在中间靠拢
		if isHeroMove(dx,dy,fx,fy) then
			
			self._hero:runAction(CCSequence:createWithTwoActions(
				CCMoveTo:create(moveTime,ccp(wx,wy)),
				CCCallFunc:create(function() self:_adjustMapByHero() end)
				))
			--transition.moveTo(self._hero,{x=wx,y=wy,time=0.5,onComplete=function() self:_adjustMapByHero() end})
		else
			
			transition.moveTo(self._map,{x=mx-offx,y=my-offy,time=moveTime,onComplete=function() self:_adjustMapByHero() end})
		end
		
	else
		
		transition.moveTo(self._hero,{x=wx,y=wy,time=moveTime,onComplete=function() self:_adjustMapByHero() end})
	end
	self._hero:playAction(dx-fx,dy-fy)
	LEvent.dispatchLEvent(LEvent.HERO_MOVE,{name="heromove",x=dx,y=dy})
	
end

function MapView:onEnter() 
	self:setTouchEnabled(true)
	self:setCascadeBoundingBox(cc.rect(0, 0,display.width,display.height))
    self:addTouchEventListener(function(event, x, y, prevX, prevY)

        if event == "began" then
            return true
        end

        if event == "moved" then

        elseif event == "ended" then
        	self:_heroMove(x,y)
        end
    end, cc.MULTI_TOUCHES_ON)
end

function MapView:onExit()
	self:removeTouchEventListener()
end

return MapView