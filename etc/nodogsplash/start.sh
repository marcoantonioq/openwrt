#!/bin/sh

(sleep 8
    echo "Baixando lista GoogleScript.." 
    wget https://script.google.com/macros/s/AKfycbz2eyxxWUpmcCeApVaVTrdbEBxPvOq68pSEMM7lI5Q2qXO46yKG2HmL/exec?action=deny -O /etc/nodogsplash/deny.txt &>/dev/null 
    wget https://script.google.com/macros/s/AKfycbz2eyxxWUpmcCeApVaVTrdbEBxPvOq68pSEMM7lI5Q2qXO46yKG2HmL/exec?action=allow -O /etc/nodogsplash/allow.txt &>/dev/null

    cp /etc/nodogsplash/deny.txt /etc/nodogsplash/htdocs/deny.txt 

    echo "Definindo regras de acesso..."

    for mac in `cat /etc/nodogsplash/allow.txt`; do
        if [ -n "$mac"  ]; then
            echo "Liberado: $mac"
            /usr/bin/ndsctl trust $mac
        fi
    done

    for mac in `cat /etc/nodogsplash/deny.txt`; do
        if [ -n "$mac"  ]; then
            echo "Bloqueado: $mac"
            /usr/bin/ndsctl deauth mac $mac
            /usr/bin/ndsctl block $mac
        fi
    done

) &
