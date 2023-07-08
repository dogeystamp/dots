# The MIT License (MIT)
# 
# Copyright (C) 2016 Jethro Kuan
# 
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
# 
# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.
# 
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.


if test -z "$Z_DATA"
    if test -z "$XDG_DATA_HOME"
        set -U Z_DATA_DIR "$HOME/.local/share/z"
    else
        set -U Z_DATA_DIR "$XDG_DATA_HOME/z"
    end
    set -U Z_DATA "$Z_DATA_DIR/data"
end

if test ! -e "$Z_DATA"
    if test ! -e "$Z_DATA_DIR"
        mkdir -p -m 700 "$Z_DATA_DIR"
    end
    touch "$Z_DATA"
end

if test -z "$Z_CMD"
    set -U Z_CMD z
end

set -U ZO_CMD "$Z_CMD"o

if test ! -z $Z_CMD
    function $Z_CMD -d "jump around"
        __z $argv
    end
end

if test ! -z $ZO_CMD
    function $ZO_CMD -d "open target dir"
        __z -d $argv
    end
end

if not set -q Z_EXCLUDE
    set -U Z_EXCLUDE "^$HOME\$"
else if contains $HOME $Z_EXCLUDE
    # Workaround: migrate old default values to a regex (see #90).
    set Z_EXCLUDE (string replace -r -- "^$HOME\$" '^'$HOME'$$' $Z_EXCLUDE)
end

# Setup completions once first
__z_complete

function __z_on_variable_pwd --on-variable PWD
    __z_add
end

function __z_uninstall --on-event z_uninstall
    functions -e __z_on_variable_pwd
    functions -e $Z_CMD
    functions -e $ZO_CMD

    if test ! -z "$Z_DATA"
        printf "To completely erase z's data, remove:\n" >/dev/stderr
        printf "%s\n" "$Z_DATA" >/dev/stderr
    end

    set -e Z_CMD
    set -e ZO_CMD
    set -e Z_DATA
    set -e Z_EXCLUDE
end
