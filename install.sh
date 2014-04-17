sudo apt-get update
sudo apt-get upgrade

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
sudo apt-get install -y redis-server
sudo apt-get install -y memcached 
sudo apt-get install -y beanstalkd
sudo apt-get install -y supervisor


# config beanstalkd
sudo sed -i "s/#START=yes/START=yes/" /etc/default/beanstalkd
sudo /etc/init.d/beanstalkd start

# config xdebug
cat << EOF | sudo tee -a /etc/php5/mods-available/xdebug.ini
xdebug.scream=1
xdebug.cli_color=1
xdebug.show_local_vars=1
EOF

# config php
sudo a2enmod rewrite
sed -i "s/error_reporting = .*/error_reporting = E_ALL/" /etc/php5/apache2/php.ini
sed -i "s/display_errors = .*/display_errors = On/" /etc/php5/apache2/php.ini
sed -i "s/disable_functions = .*/disable_functions = /" /etc/php5/cli/php.ini

sudo service apache2 restart

# composer install
curl -sS https://getcomposer.org/installer | php
sudo mv composer.phar /usr/local/bin/composer

# Added script and alias.
cd /home/vagrant
sudo wget https://gist.githubusercontent.com/santiblanko/9815306/raw/78e267d2321a361b94d767cf4b15b8a8fbdba308/serve
sudo mv serve add-site.sh
sudo chmod +x add-site.sh

cat > /home/vagrant/.bash_aliases << EOF
alias ..="cd .."
alias ...="cd ../.."
alias h='cd ~'
alias c='clear'

function serve() {
     sudo bash /vagrant/add-site.sh \$1 \$2
}
EOF
