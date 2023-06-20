config.load_autoconfig(False)

c.input.mode_override = "passthrough"
c.statusbar.show = "never"
c.tabs.show = "multiple"
c.bindings.default["passthrough"] = {}
c.bindings.commands["passthrough"] = {
    "<ctrl-escape>": "mode-leave"
}

c.url.start_pages = "https://app.discord.com"
