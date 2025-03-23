def create_left_prompt [] {
    let user_color = ansi grey
    let path_color = ansi cyan
    let separator_color = ansi grey
    let status_color = ansi dark_gray
    let uniq_color = [(whoami), (sys host).hostname] | str join
        | hash md5
        | str substring 0..5
        | ansi {fg: $'#($in)'}

    let host = (sys host).hostname | str substring ..2
    let user = whoami | str substring ..4
    let userstr = $'($user_color)($user)@($host) '

    let last_exit_code = if ($env.LAST_EXIT_CODE != 0) {([
        $status_color
        $env.LAST_EXIT_CODE
        " "
    ] | str join)

    } else { "" }

    let dir = match (do --ignore-errors { $env.PWD | path relative-to $nu.home-path }) {
        null => $env.PWD
        '' => '~'
        $relative_pwd => ([~ $relative_pwd] | path join)
    }
    let path_segment = $"($path_color)($dir)"

    [$userstr $last_exit_code $path_segment] | str join
}

$env.PROMPT_COMMAND = {|| create_left_prompt }
$env.PROMPT_COMMAND_RIGHT = {|| "" }

$env.PROMPT_INDICATOR = {|| "> " }
$env.PROMPT_INDICATOR_VI_INSERT = {|| "> " }
$env.PROMPT_INDICATOR_VI_NORMAL = {|| "> " }
