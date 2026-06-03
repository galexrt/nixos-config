.PHONY: switch
switch:
	sudo cp -rv . /etc/nixos/
	sudo nixos-rebuild switch --flake '/etc/nixos#' --show-trace --option cores 8 --option max-jobs 8

