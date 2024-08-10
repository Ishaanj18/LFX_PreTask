install:
	# Check if the containers.conf file exists, create it if it does not
	@test -f /etc/containers/containers.conf || \
		echo "[engine]\nhooks_dir = [\"/etc/containers/oci/hooks.d\"]" | sudo tee /etc/containers/containers.conf >/dev/null

	# Update the hooks_dir in containers.conf (replace with sed -i if preferred)
	sudo sed -i 's|hooks_dir.*|hooks_dir = ["/etc/containers/oci/hooks.d"]|g' /etc/containers/containers.conf
	# Load the AppArmor profile
	sudo apparmor_parser -r -W kubearmor_test-image

	# Make sure the hook script is executable
	chmod +x script.sh

	# Set up the OCI hook
	sudo mkdir -p /etc/containers/oci/hooks.d
	sudo cp oci.json /etc/containers/oci/hooks.d
	sudo cp script.sh /etc/containers/oci/hooks.d
