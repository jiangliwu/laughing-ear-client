
local ITEM_SIZE = {50,60}
local PAKEAGE_SIZE = {480+12+12,330} -- padding

local PAKEAGE_ROWS = 6
local PAKEAGE_COLS = 8
local PAKEAGE_IM = 30
local PAKEAGE_COUNTS = 240

local PackageItem = import(".PackageItem")


local Package = class("Package" , function() 
	return display.newNode()
end)


function Package:ctor() 
	print("---------------------------- time1 : Package start create  !")
	self._packNode = {}

	for i = 1,PAKEAGE_COUNTS do
		--self:updatePackNodeByIndex(i)
		self._packNode[i] = PackageItem.new(i)
	end
	print("--------------------------- time2 : Package item create success !")
	self._pageList = vv.newPageList({
                rect = CCRect(0,0,PAKEAGE_SIZE[1],PAKEAGE_SIZE[2]),
                itemSize = cc.size(ITEM_SIZE[1],ITEM_SIZE[2]),
                data = self._packNode,
                r = PAKEAGE_ROWS,
                c = PAKEAGE_COLS,
                im = PAKEAGE_IM }):pos(380,20):addTo(self)
	print("---------------------------- time3 : Package init success !")

end


function Package:updatePackNodeByIndex(index)
	self._packNode[index]:update()
end


return Package