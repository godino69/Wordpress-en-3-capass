#!/bin/bash

# Actualizar paquetes e instalar MariaDB
sudo apt update -y
sudo apt upgrade -y
sudo apt install -y mariadb-server


# Crear base de datos y usuario para WordPress
sudo mysql -e "CREATE DATABASE wordpress_db;"
sudo mysql -e "CREATE USER 'wp_user'@'%' IDENTIFIED BY 'wp_password';"
sudo mysql -e "GRANT ALL PRIVILEGES ON wordpress_db.* TO 'wp_user'@'%';"
sudo mysql -e "FLUSH PRIVILEGES;"

#Permitimos que el servidor escuche en todas las direcciones ip
sudo sed -i 's/^bind-address\s*=\s*127.0.0.1/bind-address = 0.0.0.0/' /etc/mysql/mariadb.conf.d/50-server.cnf

#Reiniciar el servicio de bases de datos
sudo systemctl restart mariadb