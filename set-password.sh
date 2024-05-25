#!/bin/bash

SCRIPT_PATH="$(realpath "$0")"
SCRIPT_DIR="$(dirname "$SCRIPT_PATH")"

STEAMRT_SNIPER_DATA_DIR="$SCRIPT_DIR/data"
STEAMRT_SNIPER_CONTAINER_NAME=`cat "$STEAMRT_SNIPER_DATA_DIR/container_name.txt"`

if [ -z "$STEAMRT_SNIPER_TARGET_USERNAME" ]; then
	read -s -p "Enter username (by default, root): " STEAMRT_SNIPER_TARGET_USERNAME
	echo

	if [ -z "$STEAMRT_SNIPER_TARGET_USERNAME" ]; then
		STEAMRT_SNIPER_TARGET_USERNAME="root"
	fi
fi

STEAMRT_SNIPER_USER_PASSWORD_PATH="$STEAMRT_SNIPER_DATA_DIR/${STEAMRT_SNIPER_TARGET_USERNAME}_password.txt"
STEAMRT_SNIPER_USER_PASSWORD=`cat "$STEAMRT_SNIPER_USER_PASSWORD_PATH" 2> /dev/null`

if [ -z "$STEAMRT_SNIPER_USER_PASSWORD" ]; then
	read -s -p "Enter $STEAMRT_SNIPER_TARGET_USERNAME password (by default, randomly): " STEAMRT_SNIPER_USER_PASSWORD
	echo

	if [ -z "$STEAMRT_SNIPER_USER_PASSWORD" ]; then
		STEAMRT_SNIPER_USER_PASSWORD=`openssl rand -base64 12 | tr -dc 'a-zA-Z0-9' | head -c 12`
		cat <<< "$STEAMRT_SNIPER_USER_PASSWORD" > $STEAMRT_SNIPER_USER_PASSWORD_PATH
	fi
fi

echo "Password stored in \"$STEAMRT_SNIPER_USER_PASSWORD_PATH\""

docker exec -u root "$STEAMRT_SNIPER_CONTAINER_NAME" usermod -p "$(echo $STEAMRT_SNIPER_USER_PASSWORD | openssl passwd -1 -stdin)" $STEAMRT_SNIPER_TARGET_USERNAME && \
echo "Successful!"
