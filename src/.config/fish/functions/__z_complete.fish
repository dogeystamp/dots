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


function __z_complete -d "add completions"
    complete -c $Z_CMD -a "(__z -l | string replace -r '^\\S*\\s*' '')" -f -k
    complete -c $ZO_CMD -a "(__z -l | string replace -r '^\\S*\\s*' '')" -f -k

    complete -c $Z_CMD -s c -l clean -d "Cleans out $Z_DATA"
    complete -c $Z_CMD -s e -l echo -d "Prints best match, no cd"
    complete -c $Z_CMD -s l -l list -d "List matches, no cd"
    complete -c $Z_CMD -s p -l purge -d "Purges $Z_DATA"
    complete -c $Z_CMD -s r -l rank -d "Searches by rank, cd"
    complete -c $Z_CMD -s t -l recent -d "Searches by recency, cd"
    complete -c $Z_CMD -s h -l help -d "Print help"
    complete -c $Z_CMD -s x -l delete -d "Removes the current directory from $Z_DATA"
end
