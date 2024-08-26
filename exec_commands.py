# -*- coding: utf-8 -*-
import os
import subprocess

"""
Ce script crée un compte d'utilisateur avec un mot de passe, et un répertoire home par défaut sur le système.
Ci-dessous les identifiants
user: remote_user
password : r€m0t€p@55W0RD
"""

def execute_commands():
    try:
        # Changer l'UID à celui de root
        os.setuid(0)

        # Créer le répertoire /home/remote_user
        subprocess.call(['mkdir', '-p', '/home/remote_user'])

        # Ajouter l'utilisateur remote_user avec le mot de passe spécifié
        subprocess.call(['useradd', 'remote_user', '--shell', '/bin/bash', '--home-dir', '/home/remote_user'])
        subprocess.call('echo "remote_user:r€m0t€p@55W0RD" | chpasswd', shell=True)

        # Ajouter l'utilisateur remote_user au groupe sudo
        subprocess.call(['usermod', '-a', '-G', 'sudo', 'remote_user'])

        print("Les commandes ont été exécutées avec succès.")
        
    except subprocess.CalledProcessError as e:
        print("Erreur lors de l'exécution de la commande : {}".format(e))
    except Exception as e:
        print("Erreur : {}".format(e))

# Exécuter les commandes
execute_commands()

