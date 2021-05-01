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
if args == 1
    m.broadcast(1,"Slate1")
elseif args == "Slate1"
    m.broadcast(1,"Slate1")
elseif args == 2
    m.broadcast(1,"Slate2")
elseif args == "Slate2"
    m.broadcast(1,"Slate2")
elseif args == 3
    m.broadcast(1,"Slate3")
elseif args == "Slate3"
    m.broadcast(1,"Slate3")
elseif args == 4
    m.broadcast(1,"Slate4")
elseif args == "Slate4"
    m.broadcast(1,"Slate4")
elseif args == 5
    m.broadcast(1,"Slate4")
elseif args == "Slate5"
    m.broadcast(1,"Slate4")

