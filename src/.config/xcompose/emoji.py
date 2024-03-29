#!/usr/bin/env python
# compiles list of emoji into valid xcompose file
# ./emoji.py > emoji

emoji = r"""
😔 pens
🤡 clow
😎 sung
👍 thu
😭 sob
🐸 frog
😇 innoc
✌️  v
😌 reliev
💀 skul
👀 eyes
👁️ eyei
👄 lips
🤔 think
👋 wave
¯\\\\\\_(ツ)\\_/¯ shrug
""".strip()

prefix = "<Multi_key> <Escape>"

print("# This file is autogenerated by emoji.py.\n")
for line in emoji.split("\n"):
    sym, name = line.split()
    codes = " ".join([f"<{char}>" for char in name])
    print(f"{prefix} {codes} : \"{sym}\"")
