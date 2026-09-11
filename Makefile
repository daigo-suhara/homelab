.PHONY: kubeconfig

MGMT_HOST ?= 172.16.0.11
MGMT_USER ?= ubuntu
KUBECONFIG ?= $(HOME)/.kube/homelab

kubeconfig:
	@mkdir -p "$(dir $(KUBECONFIG))"
	@set -eu; tmp="$(KUBECONFIG).tmp"; trap 'rm -f "$$tmp"' EXIT; \
		umask 077; ssh "$(MGMT_USER)@$(MGMT_HOST)" \
		'/snap/bin/microk8s kubectl get secret homelab-kubeconfig -n metal3 -o jsonpath="{.data.value}" | base64 -d' \
		> "$$tmp"; mv "$$tmp" "$(KUBECONFIG)"
	@echo "Saved kubeconfig to $(KUBECONFIG)"
