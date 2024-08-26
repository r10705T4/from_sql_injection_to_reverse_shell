# Utilisation de l'image de base DVWA
FROM vulnerables/web-dvwa

# Met à jour les sources Debian pour utiliser l'archive
RUN sed -i 's|http://deb.debian.org/debian|http://archive.debian.org/debian|g' /etc/apt/sources.list && \
    sed -i '/stretch-updates/d' /etc/apt/sources.list && \
    sed -i 's|http://security.debian.org|http://archive.debian.org/debian-security|g' /etc/apt/sources.list && \
    echo 'Acquire::Check-Valid-Until "false";' > /etc/apt/apt.conf.d/99no-check-valid-until

# Mise à jour des paquets et installation des dépendances
RUN apt-get update && \
    apt-get install -y vim python2.7 libcap2-bin openssh-server

# Démarre MySQL et applique les droits à l'utilisateur 'app', puis ajuste les permissions du dossier DVWA
RUN service mysql start && \
    mysql -u root -e "GRANT FILE ON *.* TO 'app'@'localhost'; FLUSH PRIVILEGES;" && \
    chmod 777 /var/www/html/dvwa

# Configure Python pour avoir la capacité SETUID
RUN setcap "cap_setuid+ep" /usr/bin/python2.7

# Ajoute cette capacité dans un fichier de configuration personnalisé
RUN echo "cap_setuid+ep /usr/bin/python2.7" >> /etc/security/capabilities.conf  

# Permet à tous les utilisateurs d'exécuter `getcap` via sudo sans mot de passe
RUN echo 'ALL ALL=(ALL) NOPASSWD: /usr/bin/getcap -r 2>/dev/null' >> /etc/sudoers

# Modifie le script principal pour démarrer le service SSH à la 7e ligne
RUN sed -i '7i service ssh start' main.sh

# Expose le port SSH
EXPOSE 22

