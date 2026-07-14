set -U __fish_git_prompt_show_informative_status 1
set -U __fish_git_prompt_showdirtystate 1
set -U __fish_git_prompt_showuntrackedfiles 1
set -U __fish_git_prompt_showupstream auto

# local bin
fish_add_path "$HOME/.local/bin"

# aliases
alias aud="sudo apt update"
alias aug="sudo apt upgrade"
alias lab="cd $HOME/Lab"
alias projects="cd $HOME/Projects"
alias scripts="cd $HOME/Lab/Scripts"
alias awslab="cd $HOME/Lab/Aws"
alias office="cd $HOME/Office"
alias fe="cd $HOME/Lab/frontend"
alias be="cd $HOME/Lab/backend"
alias work="cd $HOME/Backup/Work"
alias v="vim"
alias python="python3"
alias py="python3"
alias dfn="df -H | grep nvme"
alias dft="df -H --total | grep total"
alias t="tmux"
alias g="git"

# bun
set --export BUN_INSTALL "$HOME/.bun"
set --export PATH $BUN_INSTALL/bin $PATH

# nvm
set --export NVM_DIR $HOME/.nvm

# opencode
fish_add_path "$HOME/.opencode/bin"

# java
set --export JAVA_HOME "/usr/lib/jvm/java-21-openjdk-amd64"
set --export PATH $JAVA_HOME/bin $PATH

# android sdk
set --export ANDROID_HOME "$HOME/android_sdk"
set --export PATH $ANDROID_HOME/cmdline-tools/latest/bin $PATH
set --export PATH $ANDROID_HOME/platform-tools $PATH
set --export PATH $ANDROID_HOME/emulator $PATH
