# Installation de Vault
sudo apt-get update
sudo apt-get install unzip -y
curl -L https://releases.hashicorp.com/vault/1.3.2/vault_1.3.2_linux_amd64.zip -o vault.zip
unzip vault.zip
sudo chown root:root vault
mv vault /usr/local/bin/
rm -f vault.zip
# Création de l'utilisateur vault
adduser --no-create-home --disabled-login --gecos "" vault
# Création des répertoires et application des droits adéquats
chmod +x /usr/local/bin/vault
mkdir /etc/vault
mkdir /var/lib/vault
chown vault /var/lib/vault
chmod 700 /var/lib/vault
# Modification du binaire afin qu'il ne laisse pas d'information sensible dans le swap
setcap cap_ipc_lock=+ep /usr/local/bin/vault

# Création du service Vault
cd /lib/systemd/system/
echo "
[Unit]
Description=Vault daemon
After=network.target
[Service]
ExecStart=/usr/local/bin/vault server -config=/etc/vault/vault.conf
ExecStop=
User=vault
Group=vault
[Install]
WantedBy=multi-user.target" > vault.service

# Modification du fichier de configuration Openssl afin de désigner le localhost comme autorité de certification
cd /etc/ssl/
echo "[SANVAULT]
         subjectAltName=IP:127.0.0.1" >> openssl.cnf

# Création du certificat racine
cd /etc/vault/
openssl req -new -sha256 -x509 -extensions v3_ca -keyout ca.key -out ca_vault.crt -days 3650 -nodes -subj "/C=FR/ST=LA/L=Nantes/O=EPSi/OU=EPSI/CN=www.vault.com/emailAddress=vault@www.vault.com"
chown root:root ca.key && chmod 400 ca.key
openssl req -out vault.csr -new -newkey rsa:2048 -nodes -keyout vault.key -reqexts SANVAULT -config /etc/ssl/openssl.cnf -subj "/C=FR/ST=LA/L=Nantes/O=EPSI/OU=EPSI/CN=www.vault.com/emailAddress=vault@www.vault.com"
openssl x509 -req -days 3650 -in vault.csr -out vault.pem -CA ca_vault.crt -CAkey ca.key -CAcreateserial -extfile /etc/ssl/openssl.cnf -extensions SANVAULT
# Mise à disposition du certificat pour le distribuer à d'autres hôtes
cp ca_vault.crt /usr/local/share/ca-certificates/ && update-ca-certificates

# Modification des droits sur les fichiers pour que Vault puisse y accéder
chmod 704 vault.key
chmod 704 vault.pem

# Création du fichier de configuration Vault
echo '
# écoute sur le port 8200 pour toutes les adresses
listener "tcp" {
  address = "0.0.0.0:8200"
  tls_cert_file = "/etc/vault/vault.pem"
  tls_key_file = "/etc/vault/vault.key"
}
# module de stockage
storage "file" {
  path = "/var/lib/vault"
}' > vault.conf

# Démarrage du service Vault
systemctl enable vault.service
systemctl start vault.service
