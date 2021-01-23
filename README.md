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
function doGet(e){
  
  let action = e.parameter.action;
  let ss = SpreadsheetApp.getActive();
  let sheet = ss.getSheetByName("LOG")

  if(action == 'insert_value') 
  {
    let result = sheet.appendRow([new Date(),e.parameter.name, e.parameter.mac, e.parameter.session])
    let myJSON = JSON.stringify({method: "POST", eventObject: e, action:"Ok, vamos inserir!!!", status: result})
    sendEmails(`Dispositivo cadastrado:\n\nNome: ${e.parameter.name}\nMAC: ${e.parameter.mac}\nCPF: ${e.parameter.cpf}`)
    return ContentService.createTextOutput(myJSON).setMimeType(ContentService.MimeType.JSON);
  } 
  else if(action == 'allow') 
  {
    let list = ss.getSheetByName("ALLOW").getRange("A:A")
      .getValues()
      .filter(el => el[0])
      .toString()
      .replace(/,/g,'\n') + '\n'
    return ContentService.createTextOutput(list);
  } 
  else if(action == 'deny') 
  {
    let list = ss.getSheetByName("DENY").getRange("A:A")
      .getValues()
      .filter(el => el[0])
      .toString()
      .replace(/,/g,'\n') + '\n'
    return ContentService.createTextOutput(list);
  } 
  else 
  {
    var myJSON = JSON.stringify({name: e.parameter.name })
    return ContentService.createTextOutput(myJSON).setMimeType(ContentService.MimeType.JSON);
  }
}

const doPost = (e) =>
  ContentService.createTextOutput(
    JSON.stringify({ method: "POST", eventObject: e })
  ).setMimeType(ContentService.MimeType.JSON);

function sendEmails(texto) {
  var emailAddress = 'marco.aq7@gmail.com';
  var message = texto; 
  var subject = 'AppScript: WIFI';
  MailApp.sendEmail(emailAddress, subject, message);
}

```

## cURL

As informações são enviados como parâmetros GET, assim que um usuário loga na rede, através do script ``` nds_auth.sh  ``` para o servidor Google utilizando a ferramenta curl:

```sh
    (curl -X GET "$URL?action=insert_value&name=$3&mac=$2&cpf=$4&session=$5" &>/dev/null ) &
```