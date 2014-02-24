
local Button = class("Button",function(args)
    return cc.ui.UIPushButton.new(args.file)
end)

function Button:ctor (args) 

    self._call = args.callback

    self:onButtonPressed(function(event)
        transition.scaleTo(event.target,{time=0.05,scale=1.05})
    end)
    self:onButtonRelease(function(event)
        transition.scaleTo(event.target,{time=0.05,scale=1.00})
    end)
    self:onButtonClicked(function(event)
        if self._call then
            self._call()
        end
    end)
end

function Button:addCall(call) 
    self._call = call
    return self
end

return Button