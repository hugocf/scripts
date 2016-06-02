# NETWORK MONITORING
alias nwout='sudo tcpdump -ien1 -q src `hostname -s`'
alias nwin='sudo tcpdump -ien1 -q dst `hostname -s`'
port2pid() { 
	sudo lsof -Fp -i:$1 | xargs -I% ps -%
}
