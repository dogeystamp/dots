# https://man.sr.ht/~rjarry/aerc/integrations/password-manager.md

secret-tool lookup "$1" "$2"
# wait until the password is available
while [ $? != 0 ]; do
	secret-tool lookup "$1" "$2"
done
