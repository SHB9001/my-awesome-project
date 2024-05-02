#/bin/bash

read -p "Renseigner l url suivit du port : " prox_url
read -p "Quel utilisateur souhaitez-vous utiliser ? " user

read -s -p "Entrer le mot de passe de cet utilisateur : " password


curl --silent --insecure --data "username=$user@pam&password=$password" https://$prox_url/api2/json/access/ticket | jq --raw-output '.data.ticket' | sed 's/^/PVEAuthCookie=/' > cookie

curl --silent --insecure --data "username=$user@pam&password=$password" https://$prox_url/api2/json/access/ticket | jq --raw-output '.data.CSRFPreventionToken' | sed 's/^/CSRFPreventionToken:/' > csrftoken

curl  --insecure --cookie "$(<cookie)" https://$prox_url/api2/json/nodes | jq '.data[] | .node'

rm cookie
rm csrftoken