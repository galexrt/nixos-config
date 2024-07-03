.PHONY: switch
switch:
	sudo cp -rv . /etc/nixos/
	sudo nixos-rebuild switch --show-trace

