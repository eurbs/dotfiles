# Highly recommend installing Oh My Zsh https://ohmyz.sh/

# brew install ffmpeg
# brew install gifsicle

# === INSTALLED BY ME ===

# Resources:
#  - https://sourabhbajaj.com/mac-setup/Go/README.html
#  - https://golang.org/doc/install
# Put all of your golang repos in this path
export GOPATH=$HOME/go
# Default GOROOT is /usr/local/go
#export GOROOT=/usr/local/opt/go/libexec

export PATH=$PATH:GOPATH/bin
#export PATH=$PATH:GOROOT/bin

# ~~ pyenv ~~
# Installed using: https://opensource.com/article/19/5/python-3-default-mac
if command -v pyenv 1>/dev/null 2>&1; then
  eval "$(pyenv init -)"
fi


# ~~ NVM ~~
# Installed using: https://phoenixnap.com/kb/update-node-js-version
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# ~~ My Aliases ~~
alias lss="ls -a"

# ~~ My Functions ~~
# https://stackoverflow.com/questions/10053678/escaping-characters-in-bash-for-json
json_escape () {
    printf '%s' "$1" | python -c 'import json,sys; print(json.dumps(sys.stdin.read()))'
}

postify_data () {
    printf '%s' "$1" | python -c 'import json,sys; print("{\"Body\": " + json.dumps(sys.stdin.read()) + "}")'
}

cat_with_newlines () {
    python /Users/emileeurbanek/scripts/print_with_literal_newline_chars.py "$(cat $1)"
}

# make_gif
# ffmpeg -i ~/Desktop/select-repos.mov -filter:v "setpts=0.5*PTS" -pix_fmt rgb8 -r 10 ~/Desktop/select-repos.gif && gifsicle -O3 ~/Desktop/select-repos.gif -o ~/Desktop/select-repos.gif
# https://stackoverflow.com/questions/6121091/get-file-directory-path-from-file-path
make_gif () {
    directory=${1%/*}
    input_file=$1
    output_file=${input_file%.*}.gif
    ffmpeg -i "$1" -filter:v "setpts=0.5*PTS" -pix_fmt rgb8 -r 10 "$output_file" && gifsicle -O3 "$output_file" -o "$output_file"
}

gifify() {
    make_gif "$1"
}

# show file tree but exclude node_modules
treenode() {
    tree -dL "$1" -I node_modules
}

