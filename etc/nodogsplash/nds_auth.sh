#!/bin/sh

source /etc/nodogsplash/params.conf

echo "$@" >> /tmp/login.log

#Post GoogleScript API
sendGoogleAPI(){

    mac="$2"
    name="$3"
    pass=$4
    ( curl -X POST -H "Content-Type: application/json" -d "{ \"name\": \"$name\", \"mac\": \"$mac\", \"pass\":\"$pass\" }" $URL_API &>/dev/null ) &
}

METHOD="$1"

case "$METHOD" in
  auth_client)

      sendGoogleAPI $@

      echo 36000 0 0
      exit 0
    ;;
  client_auth|client_deauth|idle_deauth|timeout_deauth|ndsctl_auth|ndsctl_deauth|shutdown_deauth)
    INGOING_BYTES="$3"
    OUTGOING_BYTES="$4"
    SESSION_START="$5"
    SESSION_END="$6"
    # client_auth: Client authenticated via this script.
    # client_deauth: Client deauthenticated by the client via splash page.
    # idle_deauth: Client was deauthenticated because of inactivity.
    # timeout_deauth: Client was deauthenticated because the session timed out.
    # ndsctl_auth: Client was authenticated by the ndsctl tool.
    # ndsctl_deauth: Client was deauthenticated by the ndsctl tool.
    # shutdown_deauth: Client was deauthenticated by Nodogsplash terminating.
    ;;
esac
