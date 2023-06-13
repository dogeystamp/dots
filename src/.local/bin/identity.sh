#!/bin/sh
# Sets up environment variables for things I don't want to expose in my dotfiles

if [ -z "$XDG_CONFIG_HOME" ]; then
	XDG_CONFIG_HOME="$HOME"/.config
fi

IDFILE="$XDG_CONFIG_HOME"/identity

cat << "EOF" > "$IDFILE"
#!/bin/sh
# Environment variables for personal information
EOF

fields=$(mktemp)
cat << "EOF" > "$fields"
export ID_REALNAME=
export ID_EMAIL=
export ID_EMAIL_WORK=
export REALNAME=
export EMAIL=
export KEYID=
EOF

keepassxc-cli show "$KEEPASSDB" meta/identity \
	-a realname -a email -a email-work \
	-a p2p-name -a p2p-email -a p2p-keyid \
	| paste -d '' "$fields" - >> "$IDFILE"
rm "$fields"

cat << "EOF" >> "$IDFILE"
export ID_EMAIL_USER=$(basename "$ID_EMAIL" @gmail.com)
export ID_EMAIL_WORK_USER=$(basename "$ID_EMAIL_WORK" @gmail.com)
EOF
