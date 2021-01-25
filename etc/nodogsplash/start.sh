#!/bin/sh

source /etc/nodogsplash/params.conf

(sleep 1
    echo "Baixando lista GoogleScript.." 
    wget $URL_API?action=deny -O /etc/nodogsplash/deny.txt &>/dev/null 
    wget $URL_API?action=allow -O /etc/nodogsplash/allow.txt &>/dev/null

    cp /etc/nodogsplash/deny.txt /etc/nodogsplash/htdocs/deny.txt 

    echo "Definindo regras de acesso..."

    for mac in `cat /etc/nodogsplash/allow.txt`; do
        if [ `echo $mac | egrep "^([0-9A-Fa-f]{2}:){5}[0-9A-Fa-f]{2}$"` ]; then
            echo "Liberado: $mac"
            /usr/bin/ndsctl trust $mac
        fi
    done

    for mac in `cat /etc/nodogsplash/deny.txt`; do
        if [ `echo $mac | egrep "^([0-9A-Fa-f]{2}:){5}[0-9A-Fa-f]{2}$"` ]; then
            echo "Bloqueado: $mac"
            /usr/bin/ndsctl deauth mac $mac
            /usr/bin/ndsctl block $mac
        fi
    done

) &
