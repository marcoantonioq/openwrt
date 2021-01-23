#!/bin/sh

# Servidor GoogleScript
URL="https://script.google.com/macros/s/AKfycbz2eyxxWUpmcCeApVaVTrdbEBxPvOq68pSEMM7lI5Q2qXO46yKG2HmL/exec"

#Depedencias 
# opkg install nodogsplash libustream-openssl curl

#Comandos
## SSH
# scp -r etc/ root@192.168.3.1:/

## Restar NodoGsPlash
# /etc/init.d/nodogsplash restart ;  uci show nodogsplash ; ndsctl clients


METHOD="$1"
MAC="$2"

case "$METHOD" in
  auth_client)

    (curl -X GET "$URL?action=insert_value&name=$3&mac=$2&cpf=$4&session=$5" &>/dev/null ) &

    USERNAME="$3"
    PASSWORD="$4"
    # if [ "$USERNAME" = "marco" -a "$PASSWORD" = "123" ]; then
      # Allow client to access the Internet for one hour (3600 seconds)
      # Further values are upload and download limits in bytes. 0 for no limit.
      echo 36000 0 0
      exit 0
    # else
      # Deny client to access the Internet.
      # exit 1
    # fi
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