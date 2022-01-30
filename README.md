# TP3 Cloud: Déploiement d'une autorité de certification Vault avec Packer, Terraform et Scaleway 

### Rendu commun Thibaud Robin/Marie Le Roux

## Prérequis 

* Installation de Packer et Terraform sur votre machine locale. 
* Création d'une paire de clés ssh 
* Création d'un nouveau projet sur Scaleway 
* Création d'une clé API dans l'onglet "Identifiants" du projet (notez bien la clé secrète)
* Ajout de la clé ssh publique précédement créée dans l'onglet "Identifiants" du projet 
* Téléchargement du présent projet sur votre ordinateur 

## Packer 

* Modifiez le fichier image_vault.json avec les credentials de votre projet Scaleway 
* Ouvrez un terminal, placez vous dans le répertoire packer
* Lancez la commande *packer build image_vault.json* 
* A la fin de la création de l'image, copiez son ID (attention, pas celui du snapshot)

## Terraform 

* Placez vous ensuite dans le répertoire terraform 
* Lancez la commande *terraform init*
* Puis la commande *terraform plan*, vous aurez besoin de votre ID projet, de votre clé d'accès, de votre clé secrète et de l'ID de l'image précédement créée
* Enfin, lancez la commande *terraform apply* (les mêmes ID vous seront demandés à nouveau) 
* Une fois votre instance initialisée sur Scaleway, vous pouvez vous connecter en ssh au serveur Vault grâce à la clé privée associée à la clé publique donnée à Scaleway via la commande ssh root@<IP publique instance> 
  
Vous avez maintenant accès à votre autorité de certification Vault, vous pouvez dès à présent générer des certificats pour protéger vos données.
 
Le coût éstimé à l'année de cette instance est de 87.60€

## Bibliographie 

https://jeremiegoldberg.com/linfra-as-code-cest-facile/
  
https://www.vaultproject.io/docs/configuration
  
https://www.packer.io/plugins/builders/scaleway
  
https://www.digitalocean.com/community/tutorials/how-to-build-a-hashicorp-vault-server-using-packer-and-terraform-on-digitalocean-quickstart-fr

https://learn.hashicorp.com/tutorials/packer/get-started-install-cli
  
https://www.decodingdevops.com/how-to-install-terraform-on-windows-10-or-8-or-7-decodingdevops/
  

