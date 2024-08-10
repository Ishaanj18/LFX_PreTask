install:
	# Check if the containers.conf file exists, create it if it does not
	if [ ! -f /etc/containers/containers.conf ]; then \
		echo "[engine]" | sudo tee /etc/containers/containers.conf; \
		echo 'hooks_dir = ["/etc/containers/oci/hooks.d"]' | sudo tee -a /etc/containers/containers.conf; \
	else \
		# Configure the hooks definition location
		sudo sed -i '/hooks_dir/s/^#//g' /etc/containers/containers.conf; \
		sudo sed -i 's|hooks_dir.*|hooks_dir = ["/etc/containers/oci/hooks.d"]|g' /etc/containers/containers.conf; \
	fi
	
	# Load the AppArmor profile
	sudo apparmor_parser -r -W kubearmor_test-image.apparmor
	
	# Make sure the hook script is executable
	chmod +x Apparmor.sh
	
	# Set up the OCI hook
	sudo mkdir -p /etc/containers/oci/hooks.d
	echo '{
	  "version": "1.0.0",
	  "hook": {
	    "path": "/path/to/your/project/Apparmor.sh"
	  },
	  "when": {
	    "always": true
	  },
	  "stages": ["poststart"]
	}' | sudo tee /etc/containers/oci/hooks.d/names.json

uninstall:
	# Remove the AppArmor profile
	sudo apparmor_parser -R kubearmor_test-image.apparmor
	
	# Remove the OCI hook
	sudo rm /etc/containers/oci/hooks.d/names.json