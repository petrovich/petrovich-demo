pull:
	podman-compose pull

up:
	podman-compose up -d

down:
	-systemctl --user stop pod-petrovich
	podman-compose down

systemd:
	mkdir -p "$(HOME)/.config/systemd/user"
	for service in $$(podman generate systemd petrovich -f -n); do mv -fv "$$service" "$(HOME)/.config/systemd/user"; done
	systemctl --user daemon-reload
	systemctl --user enable --now pod-petrovich
