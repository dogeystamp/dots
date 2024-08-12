config.load_autoconfig(False)

c.input.mode_override = "passthrough"
c.statusbar.show = "never"
c.tabs.show = "multiple"
c.bindings.default["passthrough"] = {}
c.bindings.commands["passthrough"] = {
    "<ctrl-escape>": "mode-leave"
}

c.url.start_pages = "https://doc.dogeystamp.com"

c.downloads.location.directory = "~/quar/"
c.downloads.remove_finished = 1000
c.scrolling.smooth = True

c.colors.webpage.darkmode.enabled = True

# homegrown file selector
c.fileselect.handler = "external"
c.fileselect.multiple_files.command = ["st", "-e", "fish", "-C", "set -x OUTPUT {}; source ~/.local/bin/fish-fm"]
c.fileselect.single_file.command = ["st", "-e", "fish", "-C", "set -x OUTPUT {}; source ~/.local/bin/fish-fm"]
