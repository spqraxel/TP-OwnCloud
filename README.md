[# TP-OwnCloud](https://hub.docker.com/_/docker

importer l'image : docker pull owncloud

lancer la vm : docker run -d -p 80:80 owncloud

Une fois réaliser, allez sur votre client windows et instaler : "OwncloudClient" `https://owncloud.com/desktop-app/`

Ensuite connecté vous avec un utilisateur et le client va automatiquement syncrhonisé vos fhicer !

Vous pouvez ajouter des utilisateurs dans l'onglet utilisateur, cependant ils doivent avoir un mail et un grouppe.

Il existe également un "market" pour installer des extensions, ce qui étend les possibilités grandement, avec du LDAP par exemple, du SSL, ou encore un FTP voir du MFA

---
Documentation : https://doc.owncloud.com/desktop/next/advanced_usage/command_line_client.html
Réaliser un script de sauvegarde locale et compression

D'abbord nous allons installer le client sur notre linux en ligne de commande : https://download.owncloud.com/desktop/ownCloud/stable/latest/linux/download/

Avoir l'extension PGP installé !

Puis vous pouvez suivre les commandes et voila ! Votre clietn va etre installé, maitenant pour "importer" des fichiers de votre serveur : owncloudcmd -u USER -p PASSWORD FICHIER_LOCAL SERVEUR FICHIER ( / pour tout)

Dans notre exemple, je rentre la commande :

owncloudcmd -u admin -p admin -s --sync-hidden-files /home/Owncloud-syn/ http://192.168.20.76:80 toip

Pour le rendre automatique, je vais utilisé crontab ! 
premiere ligne qui permet de rendre la sauvegarde auto :
45 23 * * * bash /home/script.sh

Le script et dispo sur github :)
