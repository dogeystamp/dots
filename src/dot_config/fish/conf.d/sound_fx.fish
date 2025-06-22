# hook into libcanberra sound effects for fish shell events
# to disable this, run set -U NOSOUND 1

function play_sfx
	if test -n "$NOSOUND"
		return
	end

	canberra-gtk-play -i $argv > /dev/null 2>&1 & disown
end

function sfx_fail_syntax --on-event fish_posterror
	play_sfx completion-fail
end

function sfx_fail --on-event fish_postexec
	set -l cmd_status $status
	if test "$cmd_status" -ne 0
		set -l status_code (fish_status_to_signal "$cmd_status")
		if test "$status_code" = "SIGINT"
			play_sfx completion-partial
		else if test "$status_code" = "SIGQUIT"
			play_sfx outcome-failure
		else if test "$status_code" = "SIGTERM"
			play_sfx outcome-failure
		else if test "$status_code" = "SIGILL"
			# SIGILL
			play_sfx dialog-error-critical
		else if test "$status_code" = "SIGABRT"
			play_sfx dialog-error-critical
		else if test "$status_code" = "SIGKILL"
			play_sfx dialog-error-serious
		else if test "$status_code" = "SIGSEGV"
			play_sfx dialog-error-critical
		else
			play_sfx completion-fail
		end
	end
end
