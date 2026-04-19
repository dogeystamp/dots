mp.register_script_message("save", function ()
    local home = os.getenv("HOME")
    local fname = tostring(os.time(os.date("!*t"))) .. ".json"
    local path = home .. "/thi/rss/misc/" .. fname
    local sympath = home .. "/thi/rss/watch-later/" .. fname
    local f = io.open(path, "w")

    if f == nil then
        mp.osd_message(string.format("Could not save to '%s'", path))
        return
    end

    local feedname = mp.get_property("metadata/by-key/uploader")
    local title = mp.get_property("media-title")
    local link = mp.get_property("filename")

    f:write(string.format('{"feedname":%q,"title":%q,"link":%q}', feedname, title, "https://www.youtube.com/" .. link))
    f:close()
    local cmd = string.format('ln -sr "%s" "%s"', path, sympath)
    mp.commandv("run", "sh", "-c", cmd)
    mp.osd_message(string.format("Saved to '%s'", path))
end)
