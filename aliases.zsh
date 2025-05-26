# Git
alias amend="git add . && git commit --amend --no-edit"
alias commit="git add . && git commit -m"
alias diff="git diff"
alias force="git push --force-with-lease"
alias gb="git branch"
alias gc="git fetch && git checkout"
alias gl="git log --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit"
alias gs="git status"
alias gpf="git push --force-with-lease --verbose"
alias nah="git reset --hard;git clean -df"
alias pop="git stash pop"
alias prune="git fetch --prune"
alias pull="git pull --rebase"
alias push="git push"
alias resolve="git add . && git commit --no-edit"
alias stash="git stash -u"
alias uncommit="git reset HEAD^"
alias unstage="git restore --staged ."
alias wip="git add . && git commit -n -m wip"
alias ninjaedit="git add . && git commit --amend --no-verify --no-edit && git push --force-with-lease --verbose -vvv"
fixup() {
  git commit --fixup="$1"
  GIT_SEQUENCE_EDITOR=: git rebase -i --autosquash "$1"~2
}

# Directories
alias home="cd $HOME"
alias dotfiles="cd $DOTFILES"
alias library="cd $HOME/Library"
alias projects="cd $HOME/Code"

# Network
alias publicip="dig +short myip.opendns.com @resolver1.opendns.com"
alias localip="ifconfig | grep -Eo 'inet (addr:)?([0-9]*\.){3}[0-9]*' | grep -Eo '([0-9]*\.){3}[0-9]*' | grep -v '127.0.0.1'"

# OS
alias df="df -h"
alias diskusage="df"
alias fu="du -ch"
alias folderusage="fu"
alias tfu="du -sh"
alias totalfolderusage="tfu"
alias finder="open -a 'Finder' ."
alias dev="cursor . -r"
alias ping="gping"
alias reloaddns="dscacheutil -flushcache && sudo killall -HUP mDNSResponder"
alias cls="clear && printf '\e[3J'"

# Eza
alias ls="eza --icons=always --all --hyperlink --group-directories-first --classify=always --oneline"
alias l="eza --icons=always --all --hyperlink --group-directories-first --classify=always --long --git --total-size --no-user --time-style='+%Y-%m-%d %H:%M'"
alias tree="eza --icons=always --all --hyperlink --group-directories-first --classify=always --tree --recurse --git-ignore"

# ZSH
alias zshconfig="subl ~/.zshrc"
alias reload="source ~/.zshrc"

# Laravel
alias laravel="${HOME}/.composer/vendor/bin/laravel"
alias art="herd php artisan $*"
alias sail='[ -f sail ] && sh sail || sh vendor/bin/sail'
alias a.mfs='herd php artisan migrate:fresh --seed'

# PHP
alias cfresh="rm -rf vendor/ composer.lock && composer i"
alias composer="herd composer"
alias php="herd php"
pu()
{
  if [[ $# -eq 0 ]]; then
    herd php ./vendor/bin/phpunit --stop-on-failure;
  else
    herd php ./vendor/bin/phpunit --stop-on-failure --filter $1;
  fi;
}
pest()
{
  if [[ $# -eq 0 ]]; then
    herd php ./vendor/bin/pest --stop-on-failure;
  else
    herd php ./vendor/bin/pest --stop-on-failure --filter $1;
  fi;
}
alias pint="herd php -d memory_limit=-1 vendor/bin/pint"
alias rector="herd php -d memory_limit=-1 vendor/bin/rector"
alias phpstan="herd php -d memory_limit=-1 vendor/bin/phpstan"
alias pestcov="herd php -d memory_limit=-1 vendor/bin/pest --type-coverage --min=100 --compact"

# Tmux
stmx() {
  if [[ ! -n $TMUX  ]]; then
      tmux attach -t base || tmux new-session -A -s base
  fi
}
