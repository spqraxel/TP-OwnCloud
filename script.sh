#!/bin/bash

# Étape 1: Synchronisation avec Owncloud
echo "Étape 1: Synchronisation avec le dossier 'sauvegarde' sur Owncloud en cours..."
remote_path="http://192.168.20.181/remote.php/dav/files/root/sauvegarde"
local_path="/home/Owncloud-sync/"

if owncloudcmd -u root -p sio2024 --sync-hidden-files -s "$local_path" "$remote_path"; then
    echo "Étape 1: Synchronisation avec le dossier 'sauvegarde' réussie."
else
    echo "Étape 1: Erreur lors de la synchronisation avec le dossier 'sauvegarde'." >&2
    exit 1
fi

# Étape 2: Recherche des fichiers .csv
echo "Étape 2: Recherche des fichiers .csv..."
csv_files=("$local_path"*.csv)

if [ ${#csv_files[@]} -eq 0 ]; then
    echo "Étape 2: Aucun fichier .csv trouvé à déplacer et compresser." >&2
    exit 1
fi

for csv_file in "${csv_files[@]}"; do
    # Renommer le fichier .csv avec un timestamp
    new_file="${csv_file%.csv}-$(date +%d-%m-%Y-%H:%M:%S).csv"
    mv "$csv_file" "$new_file"
    if [ $? -eq 0 ]; then
        echo "Fichier .csv renommé en $new_file."
    else
        echo "Erreur lors du renommage du fichier $csv_file." >&2
        exit 1
    fi

    # Étape 3: Compression du fichier renommé en .tar
    tar_file="$new_file.tar"
    echo "Compression du fichier $new_file en $tar_file..."
    if tar -cvf "$tar_file" -C "$local_path" "$(basename "$new_file")"; then
        echo "Compression réussie en $tar_file."
    else
        echo "Erreur lors de la compression du fichier $new_file." >&2
        exit 1
    fi

    # Suppression du fichier .csv après compression
    rm "$new_file"
    if [ $? -eq 0 ]; then
        echo "Fichier $new_file supprimé après compression."
    else
        echo "Erreur lors de la suppression du fichier $new_file." >&2
        exit 1
    fi

    # Étape 4: Copie du fichier compressé vers /home/FTP/backup
    backup_dir="/home/FTP/backup"
    cp "$tar_file" "$backup_dir/"
    if [ $? -eq 0 ]; then
        echo "Fichier $tar_file copié avec succès vers $backup_dir."
    else
        echo "Erreur lors de la copie du fichier $tar_file vers $backup_dir." >&2
        exit 1
    fi

    # Étape 5: Suppression du fichier .tar après copie
    rm "$tar_file"
    if [ $? -eq 0 ]; then
        echo "Fichier $tar_file supprimé après copie."
    else
        echo "Erreur lors de la suppression du fichier $tar_file." >&2
        exit 1
    fi
done

# Fin du script
echo "Script terminé avec succès."
