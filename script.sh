#!/bin/bash

# Étape 1: Synchronisation avec Owncloud
echo "Étape 1: Synchronisation avec Owncloud en cours..."
if owncloudcmd -u admin -p admin --sync-hidden-files -s /home/Owncloud-sync/ http://192.168.20.76:80 toip; then
    echo "Étape 1: Synchronisation avec Owncloud réussie."
else
    echo "Étape 1: Erreur lors de la synchronisation avec Owncloud." >&2
    exit 1
fi

# Étape 2: Vérification de l'existence du fichier .csv
echo "Étape 2: Vérification de l'existence du fichier .csv..."
if [ -f /home/Owncloud-sync/.csv ]; then
    # Renommer le fichier .csv avec un timestamp
    new_file="/home/Owncloud-sync/sio2-$(date +%d-%m-%Y-%H:%M:%S).csv"
    mv /home/Owncloud-sync/.csv "$new_file"
    if [ $? -eq 0 ]; then
        echo "Étape 2: Fichier .csv renommé en $new_file."
    else
        echo "Étape 2: Erreur lors du renommage du fichier .csv." >&2
        exit 1
    fi

    # Étape 3: Compression du fichier .csv en .tar
    echo "Étape 3: Compression du fichier .csv en .tar..."
    if tar -cvf "$new_file.tar" -C /home/Owncloud-sync/ "$(basename "$new_file")"; then
        echo "Étape 3: Compression réussie en $new_file.tar."
    else
        echo "Étape 3: Erreur lors de la compression du fichier." >&2
        exit 1
    fi

    # Étape 4: Suppression du fichier .csv après compression
    rm "$new_file"
    if [ $? -eq 0 ]; then
        echo "Étape 4: Fichier .csv original supprimé."
    else
        echo "Étape 4: Erreur lors de la suppression du fichier .csv." >&2
        exit 1
    fi
else
    echo "Étape 2: Aucun fichier .csv trouvé à déplacer et compresser." >&2
    exit 1
fi

# Fin du script
echo "Script terminé avec succès."


