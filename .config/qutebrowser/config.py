config.load_autoconfig()

# Colors

c.colors.webpage.bg = "black"
c.colors.completion.category.bg = "#111111"
c.colors.completion.even.bg = "black"
c.colors.statusbar.private.bg = "black"
c.colors.statusbar.command.private.bg = "black"
c.colors.hints.bg = "black"
c.colors.hints.fg = "white"
c.colors.tabs.bar.bg = "black"
c.colors.webpage.darkmode.algorithm = "lightness-hsl"
c.colors.webpage.darkmode.contrast = 1.0
c.colors.webpage.darkmode.enabled = True
c.window.transparent = True

# General settings

c.scrolling.smooth = True
c.url.default_page = "about:blank"
c.url.start_pages = "about:blank"
c.url.searchengines = {"DEFAULT":"https://search.disroot.org/search?q={}"}

# Bar settings

c.tabs.max_width = 100
c.tabs.position = "bottom"
c.statusbar.show = "in-mode"

# Hints

c.hints.border = "1px dotted white"
c.hints.radius = 10
c.hints.chars = "asdf"

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
c.content.headers.do_not_track = None;

# Block certain trackers
c.content.canvas_reading = False
c.content.webgl = False
