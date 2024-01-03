
#alias ll='exa --long'
alias ll='exa --all --long'
#alias l='ls'
alias l='exa --long'
alias c='clear'
alias q='exit'
alias ,='cd ..'
alias ,,='cd'
alias rm='rm -iv'
alias p='pwd'
alias d='cd ~/mydocker'

alias s='screen -ls' # screen ls
alias sn='screen -S' # screen with name
alias sr='screen -r' # screen resume
alias srn='screen -r -s' # screen resume with name
alias m='view ~/.zshrc'
alias mf='cat ~/.zshrc | grep'
alias mfd='cat ~/.zshrc | grep docker'

alias net='sudo iftop'
alias sip='sudo iptables'
alias sips='sudo iptables -S'
alias sipl='sudo iptables -L -v'

alias ds='sudo docker start'
alias dq='sudo docker stop'
alias dpa='sudo docker ps -a'
alias dp='sudo docker ps -a --format "table {{.ID}}\t{{.Image}}\t{{.Status}}\t{{.Names}}"'
alias drm='sudo docker rm'
alias dim='sudo docker images'
alias drmi='sudo docker image rm'
alias dkci='sudo docker image prune -a' # rimuovi immagini non usate
alias dkbc='sudo docker buildx prune -f' # rimuovi tutta la cache usata per creare i container
alias dcup='sudo docker-compose up' # crea l'app completa
alias dcupd='sudo docker-compose up -d' # crea l'app completa in detached mode (no logs output)
alias dcs='sudo docker-compose start' # avvia l'app composta
alias dcq='sudo docker-compose stop' # ferma l'applicazione composta
alias dcdw='sudo docker-compose down' # ferma l'app ed elimina tutti i container (non i volumi)
alias dcp='sudo docker-compose ps' # visualizza app composte

alias rp='realpath'
alias rpr='realpath --relative-to=.'



dx() # docker exec
{ # docker exec
	sudo docker exec -it $1 /bin/bash
} # docker exec
dxc() 			# docker exec custom command
{				# docker exec custom command
	sudo docker exec -it $1 $2	
}				# docker exec custom command



source ~/powerlevel10k/powerlevel10k.zsh-theme

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
