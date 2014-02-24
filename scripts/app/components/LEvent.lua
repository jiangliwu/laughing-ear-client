LEvent = {}

LEvent.null = 0
LEvent.count = 0

function LEvent.init( size ) 
	LEvent.__dic = {}
	for i = 1 , size do
		LEvent.__dic[i] = LEvent.null
	end
	LEvent.size = size
end


function LEvent.addLEvent(eventID,handler)
	if eventID > LEvent.size then
		for i = LEvent.size + 1, LEvent.size + 64 do
			LEvent.__dic[i] = LEvent.null
		end
	end

	if LEvent.__dic[eventID] ~= LEvent.null then LEvent.count = LEvent.count + 1 end
	LEvent.size = LEvent.size + 64
	LEvent.__dic[eventID] = handler

	return handler
end

function LEvent.removeLEvent(eventID)
	if eventID == nil or  eventID > LEvent.size then
		return nil
	end

	LEvent.__dic[eventID] = LEvent.null
end

function LEvent.dispatchLEvent(eventID , args)

	if eventID == nil or eventID > LEvent.size or LEvent.__dic[eventID] == LEvent.null then
		print( " LLLLLLLL - no event " .. eventID)
		return nil
	end
	
	LEvent.count = LEvent.count - 1

	local ret = LEvent.__dic[eventID](args)
	if args ~= nil and args.remove ~= nil then LEvent.__dic[eventID] = LEvent.null end

	return ret
end


function LEvent.removeAllLEvent() 
	LEvent.count = 0
	LEvent.size = 0
	LEvent.__dic = nil
end

require('app.LEventName')