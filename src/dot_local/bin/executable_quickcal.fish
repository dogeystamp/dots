#!/usr/bin/env fish
# Use a text editor to invoke `khal new` multiple times.
#
# Each line in the text buffer will be treated as arguments passed to khal. By
# default, khal operates on today. See khal(1) for more information on the
# options you may use.

# Arguments given to this script will automatically be prepended to each
# invocation of `khal new`. For example, to add events for tomorrow, use
#
#    quickcal.fish tomorrow
#
# The contents of the text buffer will be copied to your clipboard, so that
# if khal fails, you won't lose the contents.

set TMPFILE (mktemp --suffix=.khal)

function die -d "Clean up temp files, then exit with a certain status code."
	rm "$TMPFILE"
	exit $argv
end

"$EDITOR" "$TMPFILE"; or die $status

cat "$TMPFILE" | cb -i
for line in (cat "$TMPFILE" | string split "\n")
	khal new $argv $line; or die $status
end

die 0
