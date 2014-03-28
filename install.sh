#!/usr/bin/env bash

# Este script esta basado en el setup que hizo Taylor Otwell para configurar sus maquinas virtuales en virtualBox.
# Tambien esta basado en el setup de Jeffrey Way que mostro en LARACAST.
# Se me olvidaba, tambien tiene cosas del vaprobash de fideloper...
# Muchas gracias Señores!

# Eres libre de modificarlo siempre y cuando te conviertas al toquerismo.

echo "--- Buenos días, Vamos a trabajar un rato, Athletic!!.. ---"

echo "--- Haciendo update ---"

sudo apt-get update

echo "--- Que estas mirando? Puedes ponerte a leer el marca, a echarte sueñito en el teclado o irte a tomar un cafe..."

echo "--- Athleeeeeeeeeeeeeeeeetic!! ---"

echo "--- Configurando MYSQL ---"

sudo debconf-set-selections <<< 'mysql-server mysql-server/root_password password root'
sudo debconf-set-selections <<< 'mysql-server mysql-server/root_password_again password root'

echo "--- Instalando paquetes base ---"

sudo apt-get install -y vim curl python-software-properties

echo "--- Configurando instalación de PHP, right master? ---"

sudo add-apt-repository -y ppa:ondrej/php5
sudo apt-get install python-software-properties

echo "--- Updating packages list ---"

sudo apt-get update

#Espero que esto funcione...

echo "--- Instalando paquetes ---"

sudo apt-get install -y php5 apache2 libapache2-mod-php5 php5-curl
sudo apt-get install -y php5-gd php5-mcrypt php-pear mysql-server-5.5 php5-mysql git-core redis-server
sudo apt-get install -y beanstalkd php5-xdebug


cat << EOF | sudo tee -a /etc/php5/mods-available/xdebug.ini
xdebug.scream=1
xdebug.cli_color=1
xdebug.show_local_vars=1
EOF

echo "--- Habilitando mod-rewrite ---"

sudo a2enmod rewrite

echo "--- Document root ---"

cd /home/vagrant
mkdir Scripts && cd /home/vagrant/Scripts && mkdir PhpInfo
sudo wget https://gist.githubusercontent.com/santiblanko/9815306/raw/78e267d2321a361b94d767cf4b15b8a8fbdba308/serve
sudo mv serve taylorScript.sh
sudo chmod +x taylorScript.sh

cd /home/vagrant/ && mkdir virtuals
sudo rm -rf /var/www
sudo ln -fs /vagrant/public /var/www
sudo ln -fs /vagrant/virtuals /home/vagrant/virtuals

echo  "ServerName localhost"  > /etc/apache2/conf-available/servername.conf
sudo a2enconf servername
sudo service apache2 reload

echo "--- Habilitando Errores de PHP. ---"

sed -i "s/error_reporting = .*/error_reporting = E_ALL/" /etc/php5/apache2/php.ini
sed -i "s/display_errors = .*/display_errors = On/" /etc/php5/apache2/php.ini
sed -i 's/AllowOverride None/AllowOverride All/' /etc/apache2/apache2.conf
sed -i 's/html//' /etc/apache2/sites-available/000-default.conf

echo "--- Reiniciando Apache ---"

sudo service apache2 restart

echo "--- Instalando PHPUnit ---"

wget https://phar.phpunit.de/phpunit.phar
chmod +x phpunit.phar
mv phpunit.phar /usr/local/bin/phpunit


echo "--- Instalando composer ---"
curl -sS https://getcomposer.org/installer | php
sudo mv composer.phar /usr/local/bin/composer

echo "--- Configurando beanstalkd  ---"

sudo sed -i "s/#START=yes/START=yes/" /etc/default/beanstalkd
sudo /etc/init.d/beanstalkd start

echo "--- Construyendo sitio con información de PHP ---"

echo "<?php phpinfo();" > /home/vagrant/Scripts/PhpInfo/index.php

sudo a2enmod rewrite

echo "127.0.0.1  info.app" | sudo tee -a /etc/hosts

vhost="<VirtualHost *:80>
     ServerName info.app
     DocumentRoot /home/vagrant/Scripts/PhpInfo
     <Directory \"/home/vagrant/Scripts/PhpInfo\">
          Order allow,deny
          Allow from all
          Require all granted
          AllowOverride All
    </Directory>
</VirtualHost>"

echo "$vhost" | sudo tee /etc/apache2/sites-available/info.app.conf

sudo a2ensite info.app

sudo /etc/init.d/apache2 restart

echo "---- Instalando Beanstalkd Console ---"

cd /home/vagrant/Scripts

git clone https://github.com/ptrofimov/beanstalk_console.git Beansole

echo "---- Asignando permisos ---"

sudo chmod 777 /home/vagrant/Scripts/Beansole/storage.json

sudo a2enmod rewrite

echo "127.0.0.1  beansole.app" | sudo tee -a /etc/hosts

vhost="<VirtualHost *:80>
     ServerName beansole.app
     DocumentRoot /home/vagrant/Scripts/Beansole/public
     <Directory \"/home/vagrant/Scripts/Beansole/public\">
          Order allow,deny
          Allow from all
          Require all granted
          AllowOverride All
    </Directory>
</VirtualHost>"

echo "$vhost" | sudo tee /etc/apache2/sites-available/beansole.app.conf

sudo a2ensite beansole.app
sudo /etc/init.d/apache2 restart

sudo apt-get update
sudo apt-get install -y  python g++ make
sudo add-apt-repository -y ppa:chris-lea/node.js
sudo apt-get update
sudo apt-get install -y  nodejs

echo "---- Instalando Grunt ---"
sudo npm install -g grunt-cli

echo "---- Instalando Yo ---"

sudo npm install -g yo

echo "---- Instalando Gulp ---"

sudo npm install -g gulp
