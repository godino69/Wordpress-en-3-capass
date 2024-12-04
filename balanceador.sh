#!/bin/bash

# Actualizar los paquetes del sistema
sudo apt-get update -y

# Instalar Apache2
sudo apt-get install -y apache2

# Deshabilitar el sitio por defecto
sudo a2dissite 000-default.conf

# Crear una copia del fichero de configuracion por defecto para editarlo 
sudo cp /etc/apache2/sites-available/000-default.conf /etc/apache2/sites-available/balanceador.conf

# Modificar la configuración del balanceador dirigiendo a los dos servidores web
sudo tee /etc/apache2/sites-available/balanceador.conf > /dev/null <<EOL
<VirtualHost *:80>
    ServerName localhost
    ProxyPreserveHost On
    ProxyPass / balancer://servidoresweb/
    ProxyPassReverse / balancer://servidoresweb/

    <Proxy balancer://servidoresweb>
        BalancerMember http://192.168.20.70
        BalancerMember http://192.168.20.71
        ProxySet lbmethod=byrequests
    </Proxy>

</VirtualHost>
EOL

# Habilitamos los módulos necesarios
echo "Habilitando los módulos necesarios para el balanceador..."
sudo a2enmod proxy
sudo a2enmod proxy_http
sudo a2enmod proxy_balancer
sudo a2enmod lbmethod_byrequests

# Habilitar el sitio de balanceador
sudo a2ensite balanceador.conf

# Reiniciar Apache para aplicar la configuración
sudo systemctl restart apache2

# Eliminar archivo index.html por defecto
sudo rm /var/www/html/index.html

