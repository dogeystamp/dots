#!/usr/bin/env fish

set CHROMIUM chromium
set COMMON_OPTS "--new-window"

function profile
    $CHROMIUM $COMMON_OPTS --profile-directory=$argv[1] $argv[2..]
end

function apps
    profile apps $argv
end

function discord
    profile discord --app="https://app.discord.com"
end

function sch
    profile sch --profile-directory="sch"
end

function transient
    profile transient
end

function mail
    profile mail --app="https://mail.google.com"
end

function mus
    apps --app="https://mus.dogeystamp.com"
end

function doc
    apps --app="https://doc.dogeystamp.com"
end

function forgejo
    apps "https://git.dogeystamp.com/explore"
end

function listenbrainz
    apps --app="https://listenbrainz.org"
end

$argv[1] $argv[2..]
