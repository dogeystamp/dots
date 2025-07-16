# bell notification when long-running command fails
function fail_bell --on-event fish_postexec
	set -l cmd_status $status
	if test "$cmd_status" -ne 0 && test "$CMD_DURATION" -gt 1000
		tput bel
	end
end
