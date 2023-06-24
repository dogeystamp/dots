config.load_autoconfig()

# Colors

c.colors.webpage.bg = "#444444"
c.colors.completion.category.bg = "#111111"
c.colors.completion.even.bg = "black"
c.colors.statusbar.private.bg = "black"
c.colors.statusbar.command.private.bg = "black"
c.colors.hints.bg = "black"
c.colors.hints.fg = "white"
c.colors.tabs.bar.bg = "black"

c.colors.tabs.even.bg = "#000000"
c.colors.tabs.odd.bg = "#000000"
c.colors.tabs.selected.even.bg = "#333333"
c.colors.tabs.selected.odd.bg = "#444444"

c.colors.webpage.darkmode.algorithm = "lightness-hsl"
c.colors.webpage.darkmode.contrast = 0.5
c.colors.webpage.darkmode.policy.images = "smart"
c.colors.webpage.darkmode.grayscale.images = 0.5

c.colors.prompts.bg = "black"
c.colors.prompts.border = "1px solid white"
c.prompt.radius = 0

# Fonts

c.fonts.default_family = "JetBrains Mono"
c.fonts.prompts = "default_size default_family"

config.bind('td', 'config-cycle colors.webpage.darkmode.enabled true false;; restart')

# General settings

c.scrolling.smooth = True
c.url.default_page = "~/.config/qutebrowser/homepage.html"
c.url.start_pages = "~/.config/qutebrowser/homepage.html"
c.url.searchengines = {"DEFAULT":"https://search.disroot.org/search?q={}"}
c.downloads.location.directory = "~/quar/"

c.zoom.default = "90%"

# Downloads

c.downloads.remove_finished = 1000

# Bar settings

c.tabs.max_width = 300
c.tabs.favicons.show = "never"
c.tabs.position = "bottom"
c.statusbar.show = "in-mode"
c.statusbar.widgets = [ "keypress", "progress" ]

# Hints

c.hints.border = "1px solid white"
c.hints.chars = "asdfghjklweu"

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
c.content.headers.user_agent = "Mozilla/5.0 (Android 10; Mobile; rv:91.0) Gecko/91.0 Firefox/91.0"
c.content.headers.accept_language = "en-US,en;q=0.5"
c.content.headers.custom = {"accept": "text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,*/*;q=0.8"}
# Sending a Do Not Track header makes your fingerprint more unique according to Panopticlick,
# and I don't trust sites to respect it, so I think it's better to not include it at all.
# (True: send DNT, False: Send DNT header set to 0, None: Don't send DNT)
c.content.headers.do_not_track = None

# Block certain trackers
c.content.canvas_reading = False
c.content.webgl = False

# Bind '#' key to scroll to anchor (sections in wiki pages, for example)
config.bind("#", "set-cmd-text -s :scroll-to-anchor ")
# Get image URL quickly
config.bind(";I", "hint images yank")
# This overrides pP because I don't use primary clip
config.bind("p", "open -t {clipboard}")

# code block copying
c.hints.selectors["code"] = [
    ":not(pre) > code",
    "pre"
]
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

# homegrown file selector
c.fileselect.handler = "external"
c.fileselect.multiple_files.command = ["st", "-e", "fish", "-C", "set -x OUTPUT {}; source ~/.local/bin/fish-fm"]
c.fileselect.single_file.command = ["st", "-e", "fish", "-C", "set -x OUTPUT {}; source ~/.local/bin/fish-fm"]
