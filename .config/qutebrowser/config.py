config.load_autoconfig()

c.colors.completion.category.bg = "#111111"
c.colors.completion.even.bg = "black"
c.colors.statusbar.private.bg = "black"
c.colors.hints.bg = "black"
c.colors.hints.fg = "white"
c.colors.tabs.bar.bg = "black"
c.colors.webpage.darkmode.algorithm = "lightness-hsl"
c.colors.webpage.darkmode.contrast = 1.0
c.colors.webpage.darkmode.enabled = True
c.content.javascript.enabled = False
c.content.cookies.accept = "never"
c.content.cookies.store = False
c.content.headers.user_agent = "Mozilla/5.0 (Windows NT 10.0; rv:68.0) Gecko/20100101 Firefox/68.0"
c.content.headers.accept_language = "en-US,en;q=0.5"
c.content.headers.custom = {"accept": "text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8"}
c.content.canvas_reading = False
c.content.webgl = False
c.scrolling.smooth = True
c.url.default_page = "https://dogeybox.sds-ip.de/searx/search"
c.url.searchengines = {"DEFAULT":"https://dogeybox.sds-ip.de/searx/search?q={}"}
c.url.start_pages = "https://dogeybox.sds-ip.de/searx/search"
c.window.transparent = True
c.content.private_browsing = True
c.tabs.max_width = 100
c.tabs.position = "bottom"
c.statusbar.show = "in-mode"

# This is so when using newsboat with qutebrowser,
# they can be operated using only hjkl.
config.bind('h', 'tab-close', mode='normal')
