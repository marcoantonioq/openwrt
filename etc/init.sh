#!/bin/sh

opkg update

# Depedencias
opkg install libustream-mbedtls

## AdBlock
#opkg install adblock
#opkg install luci-app-adblock


# NodoGsPlash
opkg install nodogsplash curl

# Permissões

chmod +x /etc/nodogsplash/start.sh 
chmod +x /etc/nodogsplash/nds_auth.sh 


## Start Services
/etc/nodogsplash/start.sh 


( sleep 5 
/etc/init.d/nodogsplash restart ;  uci show nodogsplash ; ndsctl clients ) &