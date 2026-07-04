function jj_prompt --description "Jujutsu VCS prompt (custom)"
    if not command -q jj
        # no jj
        return 1
    end
    if not jj root > /dev/null 2>/dev/null
        # not in jj repo
        return 1
    end

    jj log 2>/dev/null \
        --no-graph \
        --ignore-working-copy \
        --color=always \
        --revisions @ \
        --template '
            surround(
                "(",
                ")",
                separate(
                    ", ",
                    change_id.shortest(),
                    if(conflict, label("conflict", "×")),
                    if(divergent, label("divergent", "??")),
                    if(hidden, label("hidden", "hidden")),
                    if(immutable, label("node immutable", "◆")),
                    if(!empty, label("empty", "*")),
                )
            )
            '
end

function vcs_prompt --description "Fish VCS prompt (custom)"
    jj_prompt || string trim (fish_git_prompt)
end
