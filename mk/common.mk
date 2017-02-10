PRIVATE_KEY_PATH = ~/.ssh/id_rsa

generate-keypair: $(PRIVATE_KEY_PATH)

$(PRIVATE_KEY_PATH):
	ssh-keygen -b 2048 -t rsa -f $(PRIVATE_KEY_PATH) -q -N ""
