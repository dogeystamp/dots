config.load_autoconfig()

# Style

c.window.transparent = True

c.content.user_stylesheets = ["~/.config/qutebrowser/style.css"]
# c.colors.webpage.bg = "black"
c.colors.completion.category.bg = "#111111"
c.colors.completion.even.bg = "black"
c.colors.statusbar.private.bg = "white"
c.colors.statusbar.private.fg = "black"
c.colors.statusbar.command.private.bg = "white"
c.colors.statusbar.command.private.fg = "black"
c.colors.statusbar.insert.bg = "black"
c.colors.messages.info.bg = "white"
c.colors.messages.info.fg = "black"
c.colors.hints.bg = "white"
c.colors.hints.fg = "black"

c.colors.tabs.bar.bg = "black"
c.colors.tabs.even.bg = "#11111111"
c.colors.tabs.odd.bg = c.colors.tabs.even.bg
c.colors.tabs.even.fg = "#aaaaaa"
c.colors.tabs.odd.fg = c.colors.tabs.even.fg
c.colors.tabs.selected.even.bg = "#222222"
c.colors.tabs.selected.odd.bg = c.colors.tabs.selected.even.bg
c.colors.tabs.selected.even.fg = "#ffffff"
c.colors.tabs.selected.odd.fg = c.colors.tabs.selected.even.fg

# on niri wm we can just infinitely tile tabs and it's more efficient
c.tabs.tabs_are_windows = True
c.tabs.show = "never"
c.statusbar.show = "never"
# make closing tabs a no-op (last tab detection is broken)
config.bind("d", "nop")

c.colors.webpage.preferred_color_scheme = "light"
c.colors.webpage.darkmode.algorithm = "lightness-hsl"
c.colors.webpage.darkmode.contrast = 0.6
c.colors.webpage.darkmode.policy.images = "smart"

c.colors.prompts.bg = "white"
c.colors.prompts.fg = "black"
c.colors.prompts.border = "1px solid black"
c.prompt.radius = 0

# Fonts

c.fonts.default_size = "13pt"
c.fonts.default_family = "Inter Display"
c.fonts.prompts = "default_size default_family"
c.fonts.tooltip = "default_size default_family"

c.fonts.web.family.serif = "Inter"
c.fonts.web.family.sans_serif = "Inter"
c.fonts.web.family.standard = "Inter"
c.fonts.web.family.fixed = "JetBrains Mono"

# for QtWebEngine < 6.7, a :restart is needed following this
config.bind("td", "config-cycle colors.webpage.darkmode.enabled true false")

# General settings

c.url.default_page = "~/.config/qutebrowser/homepage.html"
c.url.start_pages = "~/.config/qutebrowser/homepage.html"
c.url.searchengines = {"DEFAULT": "https://html.duckduckgo.com/html?q={}"}
c.downloads.location.directory = "~/quar/"

c.zoom.default = "90%"

# Downloads

c.downloads.remove_finished = 1000

# Bar settings

c.tabs.max_width = 300
c.tabs.position = "top"
c.statusbar.show = "in-mode"
c.statusbar.widgets = ["keypress", "progress"]
c.tabs.indicator.width = 0
c.tabs.position = "bottom"
c.tabs.title.format = "{audio}{current_title}"
c.tabs.padding = dict(
    bottom=5,
    left=5,
    right=5,
    top=5,
)
c.tabs.title.alignment = "left"
c.tabs.favicons.show = "always"

# Hints

c.hints.border = "1px solid black"
c.hints.chars = "asdfhklpoqwerzxcnm"

# Privacy settings

# Disable history
c.content.private_browsing = True

# Enabling JavaScript will probably make your fingerprint completely unique.
# If you really need it, enable it on a per-site basis with the tsh and tSh
# binds which will turn on JavaScript temporarily or permanently.
c.content.javascript.enabled = False

# Tor Browser accepts cookies to make your fingerprint less unique, which I've replicated here.
# They have a "New identity" button that clears cookies. For qutebrowser,
# you'll have to restart the browser to clear them or do it manually.
# If you want to change this to completely rejecting cookies, set this to "never".
c.content.cookies.accept = "no-3rdparty"
c.content.cookies.store = False

# Less unique headers compared to the defaults
c.content.headers.accept_language = "en-US,en;q=0.5"
c.content.headers.custom = {
    "accept": "text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,*/*;q=0.8"
}
# Sending a Do Not Track header makes your fingerprint more unique according to Panopticlick,
# and I don't trust sites to respect it, so I think it's better to not include it at all.
# (True: send DNT, False: Send DNT header set to 0, None: Don't send DNT)
c.content.headers.do_not_track = None

# Block certain trackers
c.content.canvas_reading = False
c.content.webgl = False

# Bind '#' key to scroll to anchor (sections in wiki pages, for example)
config.bind("#", "cmd-set-text -s :scroll-to-anchor ")
# Get image URL quickly
config.bind(";I", "hint images yank")
# This overrides pP because I don't use primary clip
config.bind("p", "open -t {clipboard}")

# code block copying
c.hints.selectors["code"] = [":not(pre) > code", "pre"]
config.bind("cc", "hint code userscript code_select.py")

# copy the title
c.hints.selectors["title"] = [
    "h1",
    "h2",
    "h3",
    "h4",
]
config.bind("ct", "hint title userscript code_select.py")

# use libre redirects
config.bind(",fl", "hint links userscript fixlink.sh")
config.bind(",fL", "hint links userscript fixlink-tab.sh")
config.bind(",fo", "spawn --userscript fixlink.sh")

# dismiss on-screen messages
config.bind("<escape>", "clear-messages;; search")

# homegrown file selector
c.fileselect.handler = "external"
c.fileselect.multiple_files.command = [
    "alacritty",
    "-e",
    "fish",
    "-C",
    "set -x OUTPUT {}; source ~/.local/bin/fish-fm",
]
c.fileselect.single_file.command = [
    "alacritty",
    "-e",
    "fish",
    "-C",
    "set -x OUTPUT {}; source ~/.local/bin/fish-fm",
]

# smooth scroll for larger increments
# (thank you very much dima https://github.com/qutebrowser/qutebrowser/issues/6281)
config.bind(
    "<Ctrl-d>",
    "jseval -q window.scrollBy({top: window.innerHeight/1.5, left: 0, behavior: 'smooth'});",
)
config.bind(
    "<Ctrl-u>",
    "jseval -q window.scrollBy({top: -window.innerHeight/1.5, left: 0, behavior: 'smooth'});",
)
config.bind(
    "G",
    "jseval -q window.scrollBy({top: document.body.scrollHeight + 1e6, left: 0, behavior: 'smooth'});",
)
config.bind(
    "gg",
    "jseval -q window.scrollBy({top: -document.body.scrollHeight - 1e6, left: 0, behavior: 'smooth'});",
)
c.scrolling.smooth = True
