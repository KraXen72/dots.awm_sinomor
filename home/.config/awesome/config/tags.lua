local awful = require("awful")

awful.layout.layouts = {
	awful.layout.suit.tile,
}

screen.connect_signal("request::desktop_decoration", function(s)
	awful.tag({ "1", "2", "3", "4", "5", "6", "7", "8", "9" }, s, awful.layout.layouts[1])
end)

awful.mouse.snap.edge_enabled = false
