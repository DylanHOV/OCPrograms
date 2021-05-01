component = require("component")
term = require("term")
gpu = component.gpu
event = require("event")
m = component.modem
local args = {...}
function NetSetup() 
    m.open(1)
    print(m.IsOpen)
    m.broadcast(1,"Network Port Open")
    local _, _, from, port, _, message = event.pull("modem_message")
end
NetSetup()
if args == 1 then
    m.broadcast(1,"Slate1")
end
elseif args == "Slate1" then
    m.broadcast(1,"Slate1")
elseif args == 2 then
    m.broadcast(1,"Slate2")
end
elseif args == "Slate2" then
    m.broadcast(1,"Slate2")
end
elseif args == 3 then
    m.broadcast(1,"Slate3")
end
elseif args == "Slate3" then
    m.broadcast(1,"Slate3")
end
elseif args == 4 then
    m.broadcast(1,"Slate4")
end
elseif args == "Slate4" then
    m.broadcast(1,"Slate4")
end
elseif args == 5 then
    m.broadcast(1,"Slate4")
end
elseif args == "Slate5" then
    m.broadcast(1,"Slate4")
end

