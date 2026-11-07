#!/usr/bin/env fish

if command -v khal > /dev/null
    set -l CACHE_PATH "$XDG_CACHE_HOME"/next_event

	# list current event, except all day events
	khal list \
		-df "" \
		-f "{cancelled}{title} | {location} ({start-style} {to-style} {end-style})" \
		now now \
		| grep -v -- "- →)" \
		| grep -v -- "(→ -" \
		| grep -v -- "(↦ " \
		| head -n 2 \
        | read -z DATA
    if ! test -e "$CACHE_PATH" || ! printf "%s" "$DATA" | diff - $CACHE_PATH > /dev/null
        printf "%s" "$DATA" > "$CACHE_PATH"
        notify-send -a "CAL" "→ $(printf "%s" "$DATA" | head -n 1)"
    end
    printf "%s" "$DATA"
end
