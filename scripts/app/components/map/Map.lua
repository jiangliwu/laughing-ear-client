
local Map = class("Map", function(lvl)
	local map = CCTMXTiledMap:create(lvl)
	return map
end)



function Map:ctor ()
	print("################# Map loading...... ")

	self:registerScriptHandler(function(event) 
		if ( event == "enter") then
			self:onEnter()
		elseif ( event == "exit") then
			self:onExit()
		end
	end)
end

function Map:worldToTile( posx,posy,isWorld)
	
	if isWorld == nil then
		local  mx,my = self:getPosition()
		posx = posx - mx
		posy = posy - my
	end 

	local x  = posx / self:getTileSize().width
	local y = (((self:getMapSize().height) * self:getTileSize().height) - posy) / self:getTileSize().height
	return math.floor(x),math.floor(y)
end

function Map:tileToPos ( posx , posy) 

	local x = (posx + 0.5)*self:getTileSize().width
	local y = self:getContentSize().height - (posy+0.5)*self:getTileSize().width
	return x,y
end

function Map:tileToWorldPos( posx , posy )
	local x,y = self:tileToPos(posx,posy)
	local tx,ty = self:getPosition()
	return x+tx,y+ty
end


function Map:isScreenInSide( x, y)
	if x > 0 or x < display.width - self:getContentSize().width then
		return false
	end 

	if y > 0 or y < display.height - self:getContentSize().height then
		return false
	end
	return true
end

function Map:isPointInSide( x , y ) 
	local maxx = self:getMapSize().width
	local maxy = self:getMapSize().height
	if x < 0 or y < 0 or x >= maxx or y >= maxy then
		return false
	end
	return true
end

function Map:onEnter () 

end

function Map:onExit() 

end

return Map