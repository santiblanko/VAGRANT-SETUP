echo "127.0.0.1 $1" >> "/etc/hosts"

vhost="<VirtualHost *:80>
  ServerName $1
	DocumentRoot /home/vagrant/virtuals/$2
	<Directory \"/home/vagrant/virtuals/$2\">
		Order allow,deny
		Allow from all
		Require all granted
		AllowOverride All
	</Directory>
</VirtualHost>"

echo "$vhost" >> "/etc/apache2/sites-available/$1.conf"

ln -s "/etc/apache2/sites-available/$1.conf" "/etc/apache2/sites-enabled/$1.conf"

/etc/init.d/apache2 reload