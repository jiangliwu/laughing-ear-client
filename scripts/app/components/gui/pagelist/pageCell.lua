
local ScrollViewCell = import(".ScrollViewCell")
local PageCell = class("PageCell", ScrollViewCell)

function PageCell:ctor(size, itemSize , data,beginLevelIndex, endLevelIndex, rows, cols)
    local rowHeight = itemSize.width
    local colWidth = itemSize.height

    local batch = display.newNode()--display.newBatchNode(GAME_TEXTURE_IMAGE_FILENAME)
    self:addChild(batch)
    self.pageIndex = pageIndex
    self.buttons = {}

    local startX = colWidth/2  --(display.width - colWidth * (cols - 1)) / 2
    local y = size.height - rowHeight/2 --display.top - 220
    local levelIndex = beginLevelIndex

    for row = 1, rows do
        local x = startX
        for column = 1, cols do
            local icon = data[levelIndex]:pos(x,y)
            batch:addChild(icon)
            icon.levelIndex = levelIndex
            self.buttons[#self.buttons + 1] = icon

            x = x + colWidth
            levelIndex = levelIndex + 1
            if levelIndex > endLevelIndex then break end
        end

        y = y - rowHeight
        if levelIndex > endLevelIndex then break end
    end

    -- add highlight level icon
    self.highlightButton = display.newSprite("skill.png")
    self.highlightButton:setVisible(false)
    self:addChild(self.highlightButton)
end

function PageCell:onTouch(event, x, y)

    if event == "began" then
        local button = self:checkButton(x, y)
        if button then
            self.highlightButton:setVisible(true)
            self.highlightButton:setPosition(button:getPosition())
        end
    elseif event ~= "moved" then
        self.highlightButton:setVisible(false)
    end
end

function PageCell:onTap(x, y)
    local button = self:checkButton(x, y)
    if button then
        print("you click Button ".. button.levelIndex)

        if button.onTap then 
            local worldPos = button:convertToWorldSpace(ccp(0,0))
            button:onTap(worldPos.x,worldPos.y,button.levelIndex) 
        end
        --self:dispatchEvent({name = "onTapLevelIcon", levelIndex = button.levelIndex})
    end
end

function PageCell:checkButton(x, y)
    local pos = CCPoint(x, y)
    for i = 1, #self.buttons do
        local button = self.buttons[i]
        if button:getBoundingBox():containsPoint(pos) then
            return button
        end
    end
    return nil
end

return PageCell
