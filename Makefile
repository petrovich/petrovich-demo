build:
	podman build --tag=petrovich .

IMAGE ?= docker.io/nlpub/petrovich-demo

pull:
	podman pull "$(IMAGE)"

deploy:
	podman pod create --name=petrovich --publish=127.0.0.1:9292:9292
	podman container create --pod=petrovich --name=petrovich_demo --restart=always $(IMAGE)

purge:
	-systemctl --user stop pod-petrovich
	-podman stop petrovich_demo
	-podman rm petrovich_demo
	-podman pod rm petrovich

systemd:
	mkdir -p "$(HOME)/.config/systemd/user"
	for service in $$(podman generate systemd petrovich -f -n); do sed -re 's/^(WantedBy=).*$$/\1default.target/g' -i "$$service" && mv -fv "$$service" "$(HOME)/.config/systemd/user"; done
	systemctl --user daemon-reload
	systemctl --user enable --now pod-petrovich
