local List = class("List",function (args)
	return vv.newEventNode()
end)


--[[
data
nodeSize
size
]]
function List:ctor(args) 
	self._data = args.data
	self._nodeSize = args.nodeSize
	self._size = args.size

	self._tableView = CCTableView:create(self._size)
    self._tableView:setDirection(kCCScrollViewDirectionVertical)
    self._tableView:setTouchEnabled(false)
    self._tableView:setVerticalFillOrder(kCCTableViewFillTopDown)
    self:addChild(self._tableView)


    self._tableView:registerScriptHandler(handler(self,self.scrollViewDidScroll),CCTableView.kTableViewScroll)
    self._tableView:registerScriptHandler(handler(self,self.scrollViewDidZoom),CCTableView.kTableViewZoom)
    self._tableView:registerScriptHandler(handler(self,self.tableCellTouched),CCTableView.kTableCellTouched)
    self._tableView:registerScriptHandler(handler(self,self.cellSizeForTable),CCTableView.kTableCellSizeForIndex)
    self._tableView:registerScriptHandler(handler(self,self.tableCellAtIndex),CCTableView.kTableCellSizeAtIndex)
    self._tableView:registerScriptHandler(handler(self,self.numberOfCellsInTableView),CCTableView.kNumberOfCellsInTableView)
    self._tableView:reloadData()

    self:setContentSize(args.size)
end


function List:numberOfCellsInTableView() 
	return #self._data
end


function List:scrollViewDidScroll(view)
    --print("list scrollViewDidScroll")
end

function List:scrollViewDidZoom(view)
    --print("list scrollViewDidZoom")
end

function List:tableCellTouched(table,cell)
    print("cell touched at index: " .. cell:getIdx())
end

function List:cellSizeForTable(table,idx)
	return self._nodeSize[2],self._nodeSize[1]
end

function List:tableCellAtIndex(table, idx)

    local cell = table:dequeueCell()
    if nil == cell then

        cell = CCTableViewCell:new()
        local node = display.newSprite("rank_sbg.png")
        cc.ui.UILabel.new({text = self._data[idx+1].title, size = 16, color = display.COLOR_BLUE}):addTo(node):pos(20,20)
       	node:setAnchorPoint(ccp(0,0))
        cell:addChild(node)
    else

    	cell:removeAllChildrenWithCleanup(false)
    	local node = display.newSprite("rank_sbg.png")
        print("idx = "..idx+1)
    	cc.ui.UILabel.new({text = self._data[idx+1].title, size = 16, color = display.COLOR_BLUE}):addTo(node):pos(20,20)
    	node:setAnchorPoint(ccp(0,0))
        cell:addChild(node)
    end

    return cell
end


function List:onExit () 
	self:removeTouchEventListener()
end

function List:reloadList(data)
    self._data = data 
	self._tableView:reloadData()
end

function List:onEnter()

	self:setTouchEnabled(true)

    self:addTouchEventListener(function(event, x, y, prevX, prevY)
        if event == "began" then
        	local npos = self:convertToNodeSpace(ccp(x,y))
        	if npos.x > self._size.width or npos.y > self._size.height then 
        		return falses end
            return true
        end

        if event == "moved" then

        elseif event == "ended" then
        	
        end
    end, cc.MULTI_TOUCHES_ON)

end


function List:addTo(node) node:addChild(self) return self end
function List:pos(x,y) self:setPosition(ccp(x,y)) return self end

return List