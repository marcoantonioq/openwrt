# NodoGsPlash no OpenWrt 19.07

Sistema de controle de acesso com OpenWrt + GoogleSheet/Script

# Depedencias 

```
$ opkg install nodogsplash libustream-openssl curl
```

# Comandos

## NodoGsPlash

```sh
$ /etc/init.d/nodogsplash restart
```

```sh
$ uci show nodogsplash
```

```sh
$ ndsctl clients
```

# Serviços

## Servidor GoogleScript

Salva as informações de login em uma planilha do Google. Para controlar o acesso, liberado ou bloqueado, o script rodando em no AP OpenWrt /etc/nodogsplash/start.sh baixa as lista de ALLOW ou DENY na planilha. 

```js
/**
* Função POST GoogleWeb
* @param {object} e Request params
* @returns {object} TextOutputs
*/
function doPost(e) {
  let body = JSON.parse(
    decodeURI(e.postData.getDataAsString())
  )
  let pass = decodeURI(body.pass).split("%3b")
  let values = {
    ...body,
    cpf: pass[0],
    ip: pass[1],
  }
  let status = appendRow([
    new Date(),
    values.name, 
    values.mac,,
    values.ip
  ])

  sendEmails({
    message: `
    Dispositivo cadastrado:
    
    Nome: ${values.name}
    MAC: ${values.mac}
    CPF: ${values.cpf}
    IP:  ${values.ip}`
  })
  
  return createTextOutput({body:values, status: status})
    .setMimeType(ContentService.MimeType.JSON);
}

```

## [Leia mais ...](https://github.com/marcoantonioq/openwrt/tree/main/GoogleScript/)