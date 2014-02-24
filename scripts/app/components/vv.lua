local Button 	= import(".gui.Button")
local JoyStick  = import(".gui.JoyStick")
local List 		= import(".gui.List")
local Window    = import(".gui.Window")
local EventNode = import(".EventNode")

local PageList  = import(".gui.pagelist.PageList")

vv = {}

function vv.newWindow(args) 
	return Window.new(args)
end

function vv.newJoyStick(args)
	return JoyStick.new(args)
end

function vv.newList(args) 
	return List.new(args)
end

function vv.newButton(f ,c) 
	return Button.new({file=f,callback=c})
end

function vv.newEventNode() 
	return EventNode.new()
end

function vv.newList(args)
	
	local list = List.new(args)
    return list
end


function vv.newPageList(args) 
	return PageList.new(args)
end

function vv.updateTable( t )
	local ret = {}
	local index = 1
	for i=1,#t do
		if t[i] then 
			print( " updateTable " .. i)
			ret[index] = t[i]
			index = index + 1
		end
	end
	return ret
end


function vv.newConfirmWindow(content,x,y,yes,no)
	local w = vv.newWindow({
		full=true,
		close=false,
		size=cc.size(300,150)
		}):pos(x,y)

	cc.ui.UILabel.new({text = content, size = 18, color = display.COLOR_WHITE,dimensions=cc.size(300,50)}):pos(10,100):addTo(w)
	vv.newButton("button.png",function() yes() w:removeSelf() end)
		:setButtonLabel(cc.ui.UILabel.new({text = "确认", size = 16, color = display.COLOR_BLUE}))
		:pos(75,50):addTo(w)

	vv.newButton("button.png",function() ret = false w:removeSelf() end)
		:setButtonLabel(cc.ui.UILabel.new({text = "取消", size = 16, color = display.COLOR_BLUE}))
		:pos(225,50):addTo(w)

	return ret
end

function vv.newArray(cap , value) 
	local ret = {}
	for i = 1,cap do
		ret[i] = value
	end
	return ret
end


math.randomseed(os.time())
function vv.getRandomInt( a , b) 
	return math.random(a,b)
end