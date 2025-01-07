#!/usr/bin/env python3
# Copy code blocks in Qutebrowser to clipboard.

# A clipboard wrapper called `cb` is required. This is a script that switches
# between xsel and wl-copy, depending on the platform.

# See https://github.com/qutebrowser/qutebrowser/blob/master/doc/userscripts.asciidoc

import os
import html
import xml.etree.ElementTree as ET
from plumbum import local

clipboard = local.cmd.cb["-i"]


def parse_text_content(element):
    root = ET.fromstring(element)
    text = ET.tostring(root, encoding="unicode", method="text")
    text = html.unescape(text)
    return text


def send_command_to_qute(command):
    fifo = os.environ.get("QUTE_FIFO")
    if not fifo:
        raise RuntimeError("Can't read $QUTE_FIFO.")
    with open(fifo, "w") as f:
        f.write(command)


def main():
    element = os.environ.get("QUTE_SELECTED_HTML")
    code_text = parse_text_content(element)
    (clipboard << code_text)()
    send_command_to_qute("message-info 'Copied to clipboard.'")


if __name__ == "__main__":
    main()
