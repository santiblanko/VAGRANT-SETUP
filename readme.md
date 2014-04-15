# My vagrant

Sienteté del athletic mientras lo modificas a tu gusto.

## Modo de uso
Necesitas: vagrant y virtualbox (Recuerda leer un poco la doc de vagrant)
```bash
# Clonar
$ git clone https://github.com/santiblanko/Vagrant-Athletic

# Crear carpetas.
$ mkdir public && mkdir virtuals

# iniciar
vagrant up

#esperar .. .. ..

#Ejecutar en consola para agregar nuevos hosts (Local)
#phpinfo
echo "192.168.33.10  info.app" | sudo tee -a /etc/hosts
#consola beanstalkd para queues..
echo "192.168.33.10  beansole.app" | sudo tee -a /etc/hosts

#Nos conectamos via ssh
vagrant ssh
#creamos nuestro virtualhost usando taylor serve script en la carpeta Scripts
sudo ./taylorScript.sh ejemplo.app nombreDelDirectorioEnVirtuals
#(Este nos crea /sites-available/ejemplo.app.conf)
#(nos crea  /etc/apache2/sites-enabled/santi.app.conf)
#(nos modifica archivo hosts..)
```
## Por defecto

- Apache
- PHP 5.5
- Composer
- PHPUnit
- Memcached
- Redis
- MySQL (Password: toor)
- Beanstalkd Queue & Console (http://beansole.app)
- Node.js (With Grunt & Gulp & Yeoman)
- Taylor's Serve Script (Permite crear virtualhosts rapidamente)


## Agradecimentos

1.thanks to @taylorotwell @JeffreyWay & @Fideloper.
