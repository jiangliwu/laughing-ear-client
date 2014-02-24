
local PageCell = import(".PageCell")
local PageControl = import(".PageControl")
local PageList = class("PageList", PageControl)

PageList.INDICATOR_MARGIN = 45


--[[

rect    pageList rect
itemSize   PageCell item Size
data   total data , ccnode 
r      rows
c      cols
im     INDICATOR_MARGIN
]]
function PageList:ctor(args)
    PageList.super.ctor(self, args.rect, PageControl.DIRECTION_HORIZONTAL)
    self._data = args.data
    self._itemSize = args.itemSize
    PageList.INDICATOR_MARGIN = args.im or PageList.INDICATOR_MARGIN
    
    -- add cells
    local rows, cols = args.r,args.c
    local items = #self._data
    local numPages = math.ceil(items / (rows * cols))
    local levelIndex = 1

    for pageIndex = 1, numPages do
        local endLevelIndex = levelIndex + (rows * cols) - 1
        if endLevelIndex > items then
            endLevelIndex = items
        end
        local cell = PageCell.new(args.rect.size,args.itemSize,self._data,levelIndex, endLevelIndex, rows, cols)
        cell:addEventListener("onTapLevelIcon", function(event) return self:onTapLevelIcon(event) end)
        self:addCell(cell)
        levelIndex = endLevelIndex + 1
    end

    -- add indicators
    local x = (self:getClippingRect().size.width - PageList.INDICATOR_MARGIN * (numPages - 1)) / 2
    local y = self:getClippingRect().origin.y + 8

    self.indicator_ = display.newSprite("indicator1.png")
    self.indicator_:setPosition(x, y)
    self.indicator_.firstX_ = x

    for pageIndex = 1, numPages do
        local icon = display.newSprite("indicator2.png")
        icon:setPosition(x, y)
        self:addChild(icon)
        x = x + PageList.INDICATOR_MARGIN
    end

    self:addChild(self.indicator_)
end

function PageList:scrollToCell(index, animated, time)
    PageList.super.scrollToCell(self, index, animated, time)

    transition.stopTarget(self.indicator_)
    local x = self.indicator_.firstX_ + (self:getCurrentIndex() - 1) * PageList.INDICATOR_MARGIN
    if animated then
        time = time or self.defaultAnimateTime
        transition.moveTo(self.indicator_, {x = x, time = time / 2})
    else
        self.indicator_:setPositionX(x)
    end
end

function PageList:pos(x,y) 
    self:setPosition(ccp(x,y))
    return self
end

function PageList:addTo(node) 
    if node then node:addChild(self) end
    return self
end

function PageList:onTapLevelIcon(event)
    self:dispatchEvent({name = "onTapLevelIcon", levelIndex = event.levelIndex})
end

return PageList
