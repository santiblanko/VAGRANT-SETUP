# My vagrant

Sienteté del athletic mientras lo modificas a tu gusto.

## Modo de uso
```bash
# Clonar
$ git clone https://github.com/santiblanko/Vagrant-Athletic

# Crear carpetas.
$ mkdir public && mkdir virtuals

# iniciar
vagrant up

#phpinfo
echo "192.168.33.10  info.app" | sudo tee -a /etc/hosts
#consola beanstalkd para queues..
echo "192.168.33.10  beansole.app" | sudo tee -a /etc/hosts

vagrant ssh
sudo ./taylorScript.sh ejemplo.app nombreDelDirectorioEnVirtuals

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
- Serve Script

# Version mini.

Bueno aqui arriva hay muchas cosas y no siempre son necesarias.
Necesitamos una configuración express..
```bash
alias v:i="mkdir www && wget http://goo.gl/5N1zJA &&  mv 5n1zJA install.sh  && wget http://goo.gl/J1hvBz && mv J1HvBz VagrantFile && vagrant up"
```

