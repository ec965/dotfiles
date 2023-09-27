# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# load completions
fpath=(~/dotfiles/roles/zsh/files/completions $fpath)
if [ -d "$HOME/code/dev-scripts/" ]; then
  export PATH=~/code/dev-scripts:$PATH
  fpath=(~/code/dev-scripts/completions $fpath)
fi

cdg() {
  local git_root=$(git rev-parse --show-toplevel)
  if [[ -n "$git_root" ]]; then
    cd "$git_root/$1" 
  fi
}

export PATH=~/dotfiles/roles/zsh/files/scripts:$PATH
export PATH=~/.local/bin:$PATH
export PATH=~/.luarocks/bin:$PATH

export MANPAGER="sh -c 'col -bx | bat -l man -p'"
export MANROFFOPT="-c"
export BAT_PAGER='less'
export BAT_THEME='ansi'

export ZSH=$HOME/.config/zsh/oh-my-zsh
export ZSH_THEME="powerlevel10k/powerlevel10k"
plugins=( 
  asdf
  git 
  vi-mode
  docker
  docker-compose
  kubectl
  ripgrep
  fd
  zsh-syntax-highlighting
  yarn
  npm
  zoxide
  fzf
)

source $ZSH/oh-my-zsh.sh
export FZF_CTRL_T_OPTS="--preview 'bat --color=always {}'"

alias cddot='cd ~/dotfiles'
alias cdnvim='cd ~/.config/nvim'
alias gcol='git branch | fzf | sed '\''s/^.* //'\'' | xargs git checkout'
alias gitdel='~/code/dev-scripts/git-delete.sh'
alias wtb='~/code/dev-scripts/bootstrap-worktree.sh'
alias vi="nvim"
alias vim="nvim"
alias vimrc="nvim ~/.config/nvim --cmd 'cd ~/.config/nvim'"
alias conf="~/code/dev-scripts/project.sh $XDG_CONFIG_HOME"
alias dot="~/code/dev-scripts/project.sh $HOME/dotfiles $HOME/dotfiles/roles"
alias opengh="~/code/dev-scripts/open-gh.sh"
alias fnl-nvim="~/.config/nvim/scripts/fnl-nvim"
alias python="python3"

if test -f $ZDOTDIR/machine.zshrc; then 
  source $ZDOTDIR/machine.zshrc
fi

# To customize prompt, run `p10k configure` or edit ~/.config/zsh/.p10k.zsh.
[[ ! -f ~/.config/zsh/.p10k.zsh ]] || source ~/.config/zsh/.p10k.zsh
