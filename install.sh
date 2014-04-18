sudo apt-get update

# Config mysql
sudo debconf-set-selections <<< 'mysql-server mysql-server/root_password password toor'
sudo debconf-set-selections <<< 'mysql-server mysql-server/root_password_again password toor'

# Install dependencies
sudo apt-get install -y vim 
sudo apt-get install -y curl 
sudo apt-get install -y python-software-properties
sudo add-apt-repository -y ppa:ondrej/php5
sudo apt-get update
sudo apt-get install -y php5 
sudo apt-get install -y apache2 
sudo apt-get install -y libapache2-mod-php5 
sudo apt-get install -y php5-curl 
sudo apt-get install -y php5-gd 
sudo apt-get install -y php5-mcrypt 
sudo apt-get install -y php5-readline 
sudo apt-get install -y mysql-server-5.5 
sudo apt-get install -y php5-mysql 
sudo apt-get install -y git-core 
sudo apt-get install -y php5-xdebug
sudo apt-get install -y php5-sqlite
sudo apt-get install -y redis-server
sudo apt-get install -y memcached 
sudo apt-get install -y beanstalkd
sudo apt-get install -y supervisor
sudo apt-cache show supervisor
sudo apt-get install -y sqlite
sudo apt-get install -y nodejs


# apache ServerName
sudo sed -i "s/#ServerRoot.*/ServerName ubuntu/" /etc/apache2/apache2.conf
sudo /etc/init.d/apache2 restart

# config beanstalkd
sudo sed -i "s/#START=yes/START=yes/" /etc/default/beanstalkd
sudo /etc/init.d/beanstalkd start

# config php
cat << EOF | sudo tee -a /etc/php5/mods-available/xdebug.ini
xdebug.scream=1
xdebug.cli_color=1
xdebug.show_local_vars=1
EOF
sudo a2enmod rewrite
sed -i "s/error_reporting = .*/error_reporting = E_ALL/" /etc/php5/apache2/php.ini
sed -i "s/display_errors = .*/display_errors = On/" /etc/php5/apache2/php.ini
sed -i "s/disable_functions = .*/disable_functions = /" /etc/php5/cli/php.ini

sudo service apache2 restart

# composer install
curl -sS https://getcomposer.org/installer | php
sudo mv composer.phar /usr/local/bin/composer

# install PHPUnit
wget https://phar.phpunit.de/phpunit.phar
sudo chmod +x phpunit.phar
sudo mv phpunit.phar /usr/local/bin/phpunit

# Added script and alias.
mkdir /home/vagrant/virtuals 
mkdir /home/vagrant/scripts
mkdir /home/vagrant/scripts/phpInfo

script="echo \"127.0.0.1 \$1\" >> \"/etc/hosts\"

vhost=\"<VirtualHost *:80>
  ServerName \$1
    DocumentRoot /home/vagrant/virtuals/\$2/\$3
    <Directory \"/home/vagrant/virtuals/\$2\">
        Order allow,deny
        Allow from all
        Require all granted
        AllowOverride All
    </Directory>
</VirtualHost>\"

echo \"\$vhost\" >> \"/etc/apache2/sites-available/\$1.conf\"

ln -s \"/etc/apache2/sites-available/\$1.conf\" \"/etc/apache2/sites-enabled/\$1.conf\"

/etc/init.d/apache2 reload"

echo "$script" > "/home/vagrant/scripts/add-site.sh"

sudo chmod +x /home/vagrant/scripts/add-site.sh
cat > /home/vagrant/.bashrc << EOF
alias ..="cd .."
alias ...="cd ../.."
alias h='cd ~'
alias c='clear'

function serve() {
     sudo bash /home/vagrant/scripts/add-site.sh \$1 \$2 \$3
}
EOF

cd /home/vagrant/scripts
composer create-project ptrofimov/beanstalk_console -s stable /home/vagrant/scripts/beansole
echo "127.0.0.1  beansole.app" | sudo tee -a /etc/hosts
vhost="<VirtualHost *:80>
     ServerName beansole.app
     DocumentRoot /home/vagrant/scripts/beansole/public
     <Directory \"/home/vagrant/scripts/beansole/public\">
          Order allow,deny
          Allow from all
          Require all granted
          AllowOverride All
    </Directory>
</VirtualHost>"

echo "$vhost" | sudo tee /etc/apache2/sites-available/beansole.app.conf
sudo a2ensite beansole.app
sudo /etc/init.d/apache2 restart

chmod 777 /home/vagrant/scripts/beansole/storage.json

echo "<?php phpinfo();" > /home/vagrant/scripts/phpInfo/index.php

sudo a2enmod rewrite
echo "127.0.0.1  info.app" | sudo tee -a /etc/hosts
vhost="<VirtualHost *:80>
     ServerName info.app
     DocumentRoot /home/vagrant/scripts/phpInfo
     <Directory \"/home/vagrant/scripts/phpInfo\">
          Order allow,deny
          Allow from all
          Require all granted
          AllowOverride All
    </Directory>
</VirtualHost>"
echo "$vhost" | sudo tee /etc/apache2/sites-available/info.app.conf
sudo a2ensite info.app
sudo /etc/init.d/apache2 restart
