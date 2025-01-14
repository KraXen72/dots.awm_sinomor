local gears = require("gears")
local awful = require("awful")
local naughty = require("naughty")
local beautiful = require("beautiful")
local helpers = require("helpers")
require("scripts")

mod = "Mod4"
alt = "Mod1"
ctrl = "Control"
shift = "Shift"

awful.keyboard.append_global_keybindings({

	-- launch programms --

	awful.key({ mod }, "Return", function() awful.spawn("alacritty") end),
	awful.key({ mod }, "e", function() awful.spawn("thunar") end),
	awful.key({ mod }, "b", function() awful.spawn("librewolf") end),
	awful.key({ mod }, "a", function() awful.spawn("ayugram-desktop" or "telegram-desktop") end),
	awful.key({}, "Print", function() awful.spawn("flameshot gui") end),

	-- some scripts --

	awful.key({ mod, ctrl }, "p", function() awful.spawn.with_shell("~/.local/bin/colorpicker", false) end),
	awful.key({ mod, ctrl }, "q", function() awful.spawn.with_shell("~/.local/bin/qr_codes", false) end),

	-- playerctl --

	awful.key({}, "XF86AudioPlay", function()
		awful.spawn.with_shell("playerctl play-pause")
	end),
	awful.key({}, "XF86AudioPrev", function()
		awful.spawn.with_shell("playerctl previous")
	end),
	awful.key({}, "XF86AudioNext", function()
		awful.spawn.with_shell("playerctl next")
	end),

	-- volume up/down/mute --

	awful.key({}, "XF86AudioRaiseVolume", function()
		awful.spawn.with_shell("amixer -D pipewire sset Master 2%+")
		updateVolumeSignals()
		awesome.emit_signal("summon::osd")
	end),
	awful.key({}, "XF86AudioLowerVolume", function()
		awful.spawn.with_shell("amixer -D pipewire sset Master 2%-")
		updateVolumeSignals()
		awesome.emit_signal("summon::osd")
	end),
	awful.key({}, "XF86AudioMute", function()
		awful.spawn.with_shell("amixer -D pipewire sset Master toggle")
		updateVolumeSignals()
		awesome.emit_signal("summon::osd")
	end),

	-- brightness up/down --

	awful.key({}, "XF86MonBrightnessUp", function()
		awful.spawn.with_shell("brightnessctl s 5%+")
		update_value_of_bright()
		awesome.emit_signal("summon::osd")
  end),
	awful.key({}, "XF86MonBrightnessDown", function()
		awful.spawn.with_shell("brightnessctl s 5%-")
		update_value_of_bright()
		awesome.emit_signal("summon::osd")
	end),

	-- binds to widgets --

	awful.key({ mod, ctrl }, "b", function() awesome.emit_signal("summon::books") end),
	awful.key({ mod, ctrl }, "c", function() awesome.emit_signal("summon::clipboard") end),
	awful.key({ mod }, "d", function() awesome.emit_signal("summon::launcher") end),
	awful.key({ mod }, "x", function() awesome.emit_signal("summon::powermenu") end),
	awful.key({ mod }, "m", function() awesome.emit_signal("signal::dnd") end),
	awful.key({ mod }, "w", function() awesome.emit_signal("summon::wifi_popup") end),
	awful.key({ mod }, "n", function() awesome.emit_signal("notif_center::open") end),
	awful.key({ mod }, "c", function() awesome.emit_signal("time::calendar") end),
	awful.key({ mod }, "p", function() awesome.emit_signal("profile::control") end),
	awful.key({ mod, shift }, "b", function() awesome.emit_signal("hide::bar") end),
	awful.key({ mod }, "t", function() awesome.emit_signal("show::tray") end),

	-- switching a focus client -- 

	awful.key({ mod }, "l", function () awful.client.focus.byidx(1) end),
	awful.key({ mod }, "h", function () awful.client.focus.byidx(-1) end),

	-- focus to tag --

	awful.key {
		modifiers = { mod },
		keygroup = "numrow",
		on_press = function (index)
		local screen = awful.screen.focused()
		local tag = screen.tags[index]
		if tag then
			tag:view_only()
		end
	end},

	-- move focused client to tag --

	awful.key {
		modifiers = { mod, shift },
		keygroup = "numrow",
		on_press = function (index)
		if client.focus then
			local tag = client.focus.screen.tags[index]
			if tag then
				client.focus:move_to_tag(tag)
			end
		end
	end},

	-- restart wm --

	awful.key({ mod, shift }, "r", awesome.restart),

	-- resize client --

   awful.key({ mod, ctrl }, "k", function(c)
		helpers.client.resize_client(client.focus, "up")
	end),
	awful.key({ mod, ctrl }, "j", function(c)
		helpers.client.resize_client(client.focus, "down")
	end),
	awful.key({ mod, ctrl }, "h", function(c)
		helpers.client.resize_client(client.focus, "left")
	end),
	awful.key({ mod, ctrl }, "l", function(c)
		helpers.client.resize_client(client.focus, "right")
	end),

	-- change padding tag on fly --

	awful.key({ mod, shift }, "=", function()
		helpers.client.resize_padding(5)
	end),
	awful.key({ mod, shift }, "-", function()
		helpers.client.resize_padding(-5)
	end),

	-- change useless gap on fly --

	awful.key({ mod }, "=", function()
		helpers.client.resize_gaps(5)
	end),
	awful.key({ mod }, "-", function()
		helpers.client.resize_gaps(-5)
	end),

})


-- mouse binds --

client.connect_signal("request::default_mousebindings", function()
	awful.mouse.append_client_mousebindings({
		awful.button({ }, 1, function (c)
			c:activate { context = "mouse_click" }
		end),
		awful.button({ mod }, 1, function (c)
			c:activate { context = "mouse_click", action = "mouse_move"  }
		end),
		awful.button({ mod }, 3, function (c)
			c:activate { context = "mouse_click", action = "mouse_resize" }
		end),
	})
end)

-- client binds --

client.connect_signal("request::default_keybindings", function()

	awful.keyboard.append_client_keybindings({
		awful.key({ mod }, "f",
			function (c)
				c.fullscreen = not c.fullscreen
				c:raise()
			end),
		awful.key({ mod }, "q", function (c) c:kill() end),
		awful.key({ mod }, "s", awful.client.floating.toggle),

		awful.key({ mod, shift }, "n", function (c)
				c.minimized = true
		end),

		awful.key({ mod, shift}, "m", function (c)
			c.maximized = not c.maximized
			c:raise()
		end),

		-- Move or swap by direction --

		awful.key({ mod, shift }, "k", function(c)
			helpers.client.move_client(c, "up")
		end),
		awful.key({ mod, shift }, "j", function(c)
			helpers.client.move_client(c, "down")
		end),
		awful.key({ mod, shift }, "h", function(c)
			helpers.client.move_client(c, "left")
		end),
		awful.key({ mod, shift }, "l", function(c)
			helpers.client.move_client(c, "right")
		end),

		--- Relative move  floating client --

		awful.key({ mod, shift, ctrl }, "j", function(c)
			c:relative_move(0, 20, 0, 0)
		end),
		awful.key({ mod, shift, ctrl }, "k", function(c)
			c:relative_move(0, -20, 0, 0)
		end),
		awful.key({ mod, shift, ctrl }, "h", function(c)
			c:relative_move(-20, 0, 0, 0)
		end),
		awful.key({ mod, shift, ctrl }, "l", function(c)
			c:relative_move(20, 0, 0, 0)
		end),

	})

end)


