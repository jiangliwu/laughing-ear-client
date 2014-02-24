
function __G__TRACKBACK__(errorMessage)
    print("----------------------------------------")
    print("LUA ERROR: " .. tostring(errorMessage) .. "\n")
    print(debug.traceback("", 2))
    print("----------------------------------------")
end

Base = {
	name="name",
	getname = function (self)
	return self.name;
	end
}


require("app.MyApp").new():run()
