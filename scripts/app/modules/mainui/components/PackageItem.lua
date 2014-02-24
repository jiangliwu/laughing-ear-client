
--local ITEM_DELETE = 1<<1
--local ITEM_EQUIP  = 1<<2
--local ITEM_SELL   = 1<<3
--local ITEM_BUY    = 1<<4

local WINDOW_WIDTH = 200


local PackageItem = class("PackageItem",function(index)
	return display.newSprite("item.png")
end)


function PackageItem:ctor(index)

	
	self._index = index
	self._itemType = 0
	self:update()
end

function PackageItem:update() 
	self:removeAllChildren()

	self._itemType = Cache.packageData[self._index]
	local itemText
	if self._itemType == 0 then 
		itemText = "空"
	else 
		itemText = self._itemType..""
	end
	cc.ui.UILabel.new({text = itemText, size = 18, color = display.COLOR_BLUE}):pos(18,18):addTo(self)
end

function PackageItem:onTap(x,y)
	if self._itemType == 0 then return nil end
	if Cache.items then
		local itemInfo = Cache.items[self._itemType+1]
		self:_createTipWindow(x,y,itemInfo.title,itemInfo.content,itemInfo.op)
	end

	--LEvent.dispatch...
end


function PackageItem:_createTipWindow(x,y,title,content,op)
	
	local tl = cc.ui.UILabel.new({text = title, size = 24, color = display.COLOR_BLUE,dimensions=cc.size(WINDOW_WIDTH-10,50)}):pos(10,200)
	local cl = cc.ui.UILabel.new({text = content, size = 18, color = display.COLOR_WHITE , dimensions=cc.size(WINDOW_WIDTH-10,50)}):pos(10,200-tl:getContentSize().height)

	

	local w = vv.newWindow({
			tip=true,
			size=cc.size(WINDOW_WIDTH,300),
			close=true,
			closeCallback = function () print("------") end
	}):pos(x,y)

	
	local ob = vv.newButton("button.png",
		function()
			vv.newConfirmWindow("确认丢弃物品吗?",x,y,function()  LEvent.dispatchLEvent(LEvent.ITEM_DELETE,{index=self._index}) w:removeSelf() end , function() end )
		end):setButtonLabel(cc.ui.UILabel.new({text = "丢弃", size = 16, color = display.COLOR_BLUE}))
		:pos(WINDOW_WIDTH/2,50):addTo(w)

	w:addChild(tl)
	w:addChild(cl)
	

end
return PackageItem