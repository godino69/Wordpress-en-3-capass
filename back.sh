#!/bin/bash

# Actualizar paquetes e instalar Apache, PHP y cliente NFS
sudo apt update -y
sudo apt-get install -y apache2 php libapache2-mod-php php-mysql nfs-common

# Crear punto de montaje para el recurso NFS
sudo mkdir -p /mnt/nfs

# Montamos el recurso NFS
sudo mount 192.168.20.72:/var/nfs/shared /mnt/nfs

# Configurar montaje automático en /etc/fstab
echo "192.168.20.72:/var/nfs/shared /mnt/nfs nfs defaults 0 0" | sudo tee -a /etc/fstab

# Crearemos una configuración de Apache para apuntar a /mnt/nfs donde está WordPress
sudo cp /etc/apache2/sites-available/000-default.conf /etc/apache2/sites-available/wordpress.conf 
# Deshabilitar el sitio por defecto
sudo a2dissite 000-default.conf

# Crear una nueva configuración para WordPress
sudo tee /etc/apache2/sites-available/wordpress.conf > /dev/null <<EOL
<VirtualHost *:80>
    ServerName localhost
    DocumentRoot /mnt/nfs
    <Directory /mnt/nfs>
        Options Indexes FollowSymLinks
        AllowOverride All
        Require all granted
    </Directory>
    SetEnvIf X-Forwarded-Proto "https" HTTPS=on
</VirtualHost>
EOL


# Habilitar el sitio de WordPress y reiniciar Apache
sudo a2ensite wordpress.conf
sudo a2enmod rewrite
sudo systemctl restart apache2
sudo systemctl daemon-reload 
sudo systemctl enable apache2
