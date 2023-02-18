export EDITOR='helix'
export VISUAL='helix'

PS1='[\u@\h \W]\$ '

if [ -d "$HOME/.bin" ] ;
  then PATH="$HOME/.bin:$PATH"
fi

if [ -d "$HOME/.local/bin" ];
  then PATH="$HOME/.local/bin:$PATH"
fi

bind "set completion-ignore-case on"

alias ls='ls --color=auto'
alias update='doas pacman -Syyu'
alias grep='grep --color=auto'
alias cleanup='doas pacman -Rns $(pacman -Qtdq)'

complete -cf doas

