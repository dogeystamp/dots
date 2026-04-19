-- default config at /usr/share/swayimg/example.lua

-- General config
swayimg.enable_decoration(false)           -- window title/buttons/borders

-- Text overlay configuration
swayimg.text.set_font("Inter Display")        -- font name
swayimg.text.set_size(24)                 -- font size in pixels
swayimg.text.set_background(0x88f7f7f7)   -- foreground text color
swayimg.text.set_foreground(0xff000000)   -- text background color
swayimg.text.set_shadow(0xfffffff)       -- text shadow color
swayimg.text.set_timeout(0)               -- layer hide timeout
swayimg.text.set_status_timeout(0)        -- status message hide timeout

-- Image viewer mode
swayimg.viewer.set_window_background(0xfff7f7f7) -- window background color
swayimg.viewer.set_image_chessboard(20, 0x44333333, 0x444c4c4c) -- chessboard

swayimg.viewer.on_key("q", function()
  swayimg.exit()
end)
swayimg.gallery.on_key("q", function()
  swayimg.exit()
end)
swayimg.viewer.on_key("h", function()
  local wnd = swayimg.get_window_size()
  local pos = swayimg.viewer.get_position()
  swayimg.viewer.set_abs_position(math.floor(pos.x + wnd.width / 10), pos.y);
end)
swayimg.viewer.on_key("l", function()
  local wnd = swayimg.get_window_size()
  local pos = swayimg.viewer.get_position()
  swayimg.viewer.set_abs_position(math.floor(pos.x - wnd.width / 10), pos.y);
end)
swayimg.viewer.on_key("j", function()
  local wnd = swayimg.get_window_size()
  local pos = swayimg.viewer.get_position()
  swayimg.viewer.set_abs_position(pos.x, math.floor(pos.y - wnd.height / 10));
end)
swayimg.viewer.on_key("k", function()
  local wnd = swayimg.get_window_size()
  local pos = swayimg.viewer.get_position()
  swayimg.viewer.set_abs_position(pos.x, math.floor(pos.y + wnd.height / 10));
end)

-- Gallery mode
swayimg.gallery.set_border_color(0xffaaaaaa)        -- border color for selected thumbnail
swayimg.gallery.set_selected_scale(1.0)            -- scale for selected thumbnail
swayimg.gallery.set_selected_color(0x44444444)      -- background color for selected thumbnail
swayimg.gallery.set_unselected_color(0x44444444)    -- background color for unselected thumbnail
swayimg.gallery.set_window_color(0xfff7f7f7)        -- window background color

swayimg.gallery.on_key("h", function()
  swayimg.gallery.switch_image("left")
end)
swayimg.gallery.on_key("l", function()
  swayimg.gallery.switch_image("right")
end)
swayimg.gallery.on_key("k", function()
  swayimg.gallery.switch_image("up")
end)
swayimg.gallery.on_key("j", function()
  swayimg.gallery.switch_image("down")
end)
