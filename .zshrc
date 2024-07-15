# Highly recommend installing Oh My Zsh https://ohmyz.sh/

ZSH_THEME="robbyrussell-clone"

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

# ~~ thefuck ~~
# Installed with `brew install thefuck`
eval $(thefuck --alias)

# ~~ NVM ~~
# Installed using: https://phoenixnap.com/kb/update-node-js-version
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# ~~ My Aliases ~~
alias lss="ls -a"
alias branches="git for-each-ref --sort=-committerdate --color=always --format '%(color:cyan)%(refname:short) %(color:reset)| %(subject) | %(color:magenta)%(committerdate:relative)' refs/heads"

# ~~ My Functions ~~
get_started() {
    # Install Homebrew
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    # Install my fav packages
    brew install ffmpeg
    brew install gifsicle

    brew install fzf
    $(brew --prefix)/opt/fzf/install
    # NOTE: this is how u uninstall fzf:  $(brew --prefix)/opt/fzf/uninstall

    brew install tree
    # This is for use with django_extensions
    brew install graphviz
    export LIBRARY_PATH=$LIBRARY_PATH:/opt/homebrew/Cellar/graphviz/7.1.0

    # https://github.com/nvbn/thefuck
    brew install thefuck
}


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

gifify_same_speed() {
    directory=${1%/*}
    input_file=$1
    output_file=${input_file%.*}.gif
    ffmpeg -i "$1" -pix_fmt rgb8 -r 10 "$output_file" && gifsicle -O3 "$output_file" -o "$output_file"
}

compress_video () {
    input_file=$1
    directory=${1%/*}
    extension=${input_file##*.}
    output_file=${input_file%.*}_compressed.${extension}

    # make the number after -crf bigger for more compression, smaller for less
    ffmpeg -i "$input_file" -c:v libx264 -c:a copy -crf 20 "$output_file"
}

compress_and_gifify_slight_speedup () {
    directory=${1%/*}
    input_file=$1
    extension=${input_file##*.}
    sped_up_output_file=${input_file%.*}_sped_up.${extension}
    compressed_output_file=${input_file%.*}_compressed.${extension}
    output_file=${input_file%.*}.gif

    echo 'ffmpeg -i "$input_file" -c:v libx264 -c:a copy -crf 28 "$compressed_output_file"'
    ffmpeg -i "$input_file" -c:v libx264 -c:a copy -crf 28 "$compressed_output_file"
    echo 'ffmpeg -i "$compressed_output_file" -filter:v "setpts=0.8*PTS" -pix_fmt rgb8 -r 10 "$output_file"'
    ffmpeg -i "$compressed_output_file" -filter:v "setpts=0.8*PTS" -pix_fmt rgb8 -r 10 "$output_file"
    echo 'gifsicle -O3 "$output_file" -o "$output_file"'
    gifsicle -O3 "$output_file" -o "$output_file"

    rm "$compressed_output_file"
}

# show file tree but exclude node_modules
treenode() {
    tree -dL "$1" -I node_modules
}

# get git stats for files
alias gitstatsshort="git shortlog -sne"

gitstatss() {
    git log --author="eurbs@users.noreply.github.com" --pretty=format: --numstat | awk '{ add += $1; subs += $2; loc += $1 - $2 } END { printf "added lines: %s, removed lines: %s, total lines: %s\n", add, subs, loc }' -
}

# Django things
alias dredis="redis-server"
alias delastic="elasticsearch"
alias ddynamo="docker run -p 8001:8001 amazon/dynamodb-local -jar DynamoDBLocal.jar -port 8001"
alias dbetest="pytest apps"
alias dbestart="python manage.py runserver"
alias ddjshell="python manage.py shell"
alias ddjshell2="python manage.py shell_plus --ipython"
