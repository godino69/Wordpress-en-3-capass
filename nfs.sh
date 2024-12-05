#!/bin/bash

# Actualizar paquetes del sistema
sudo apt update -y
sudo apt upgrade -y

# Instalarmos el servidor NFS
sudo apt-get install -y nfs-kernel-server unzip

# Crear el directorio compartido si no existe para que se comparta a los otros servidores,
sudo mkdir -p /var/nfs/shared


# Descargar e instalar WordPress en el directorio compartido.

cd /var/nfs/shared
sudo wget https://wordpress.org/latest.tar.gz
sudo tar -xvzf latest.tar.gz
sudo mv wordpress/* /var/nfs/shared/
sudo rm -rf wordpress latest.tar.gz


# Crear wp-config.php a partir del archivo wp-config-sample.php
sudo cp /var/nfs/shared/wp-config-sample.php /var/nfs/shared/wp-config.php

# Configurar la base de datos en wp-config.php
sudo sed -i 's/define(.*DB_NAME.*)/define("DB_NAME", "wordpress_db");/' /var/nfs/shared/wp-config.php
sudo sed -i 's/define(.*DB_USER.*)/define("DB_USER", "wp_user");/' /var/nfs/shared/wp-config.php
sudo sed -i 's/define(.*DB_PASSWORD.*)/define("DB_PASSWORD", "wp_password");/' /var/nfs/shared/wp-config.php
sudo sed -i 's/define(.*DB_HOST.*)/define("DB_HOST", "192.168.20.135");/' /var/nfs/shared/wp-config.php

# Le añadimos la ip del balanceador para que salga por ahi nustra página web
echo "define('WP_HOME', 'http://98.83.68.240');" | sudo tee -a /var/nfs/shared/wp-config.php > /dev/null
echo "define('WP_SITEURL', 'http://98.83.68.240');" | sudo tee -a /var/nfs/shared/wp-config.php > /dev/null

# Configurar las exportaciones NFS para que permita permita a los otros dos servidores
sudo sh -c 'cat > /etc/exports <<EOL
/var/nfs/shared 192.168.20.70(rw,sync,no_subtree_check)
/var/nfs/shared 192.168.20.71(rw,sync,no_subtree_check)
EOL'

# Ajustar permisos para el directorio compartido
sudo chown -R www-data:www-data /var/nfs/shared
sudo chmod -R 755 /var/nfs/shared


# Exportar el directorio NFS
sudo exportfs -a

# Reiniciar el servicio NFS
sudo systemctl restart nfs-kernel-server
sudo systemctl enable nfs-kernel-server
