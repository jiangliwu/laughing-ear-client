
local WebSockets = class("WebSockets")

WebSockets.TEXT_MESSAGE = 0
WebSockets.BINARY_MESSAGE = 1
WebSockets.BINARY_ARRAY_MESSAGE = 2


function WebSockets:ctor(url)
    --require("framework.api.EventProtocol").extend(self)
    self.socket = WebSocket:create(url)

    if self.socket then
        self.socket:registerScriptHandler(handler(self, self.onOpen_), kWebSocketScriptHandlerOpen)
        self.socket:registerScriptHandler(handler(self, self.onMessage_), kWebSocketScriptHandlerMessage)
        self.socket:registerScriptHandler(handler(self, self.onClose_), kWebSocketScriptHandlerClose)
        self.socket:registerScriptHandler(handler(self, self.onError_), kWebSocketScriptHandlerError)
    end
end

function WebSockets:isReady()
    return self.socket and self.socket:getReadyState() == kStateOpen
end

function WebSockets:send(data, messageType)
    if not self:isReady() then
        echoError("WebSockets:send() - socket is't ready")
        return false
    end

    messageType = toint(messageType)
    if messageType == WebSockets.TEXT_MESSAGE then
        self.socket:sendTextMsg(tostring(data))
    elseif messageType == WebSockets.BINARY_ARRAY_MESSAGE then
        data = totable(data)
        self.socket:sendBinaryMsg(data, table.nums(data))
    else
        self.socket:sendBinaryStringMsg(tostring(data))
    end
    return true
end

function WebSockets:close()
    if self.socket then
        self.socket:close()
        self.socket = nil
    end
    self:removeAllEventListeners()
end

function WebSockets:onOpen_()
    LEvent.dispatchLEvent(LEvent.WEB_SOCKET_OPEN);
end

function WebSockets:onMessage_(message, messageLength)
    LEvent.dispatchLEvent(LEvent.WEB_SOCKET_MESSAGE,{message=message,messageLength=messageLength})
end

function WebSockets:onClose_()
    print("WEB_SOCKET_CLOSE onClose_")
    LEvent.dispatchLEvent(LEvent.WEB_SOCKET_CLOSE)
    self:close()
end

function WebSockets:onError_(error)
    print("onError_ WEB_SOCKET_ERROR")
    LEvent.dispatchLEvent(LEvent.WEB_SOCKET_ERROR)
end

return WebSockets
