# docker-centos-abdi

*Atenção*, essa imagem contém:

* Sistema Operacional: CentOS versão 7
* PHP 7.2, com driver SQL SERVER configurado
* xdebug 2.9.8
* Apache 

A imagem já starta o apache automatico não sendo necessário configurar nada no docker-compose. Sintam-se livres para melhorar algo se necessário.

#Habilitando xdebug
no docker-compose.yml mapeie um arquivo conforme a seguir:

<pre>
volumes:
    - ./docker/xdebug.ini:/etc/php.d/15-xdebug.ini
</pre>

xdebug.ini
<pre>
    zend_extension=/usr/lib64/php/modules/xdebug.so
    xdebug.remote_enable=1
    xdebug.remote_handler=dbgp
    xdebug.remote_port=9000
    xdebug.remote_autostart=1
    xdebug.remote_connect_back=1
    xdebug.idekey=PHPSTORM
</pre>

#Utilização de entrypoint
Para utilizar entrypoint usa-se a seguinte configuração no docker-composer.yml
<pre>
entrypoint: [ "/bin/sh" , "/var/www/html/docker/entrypoint.sh", "/usr/sbin/httpd", "-D", "FOREGROUND"]
</pre>
entrypoint.sh

<pre>
#!/bin/sh
set -e
echo "[ ****************** ] Back - Starting Endpoint of Application"

cd /var/www/html

[...]


echo "[ ****************** ] Back - Finalizando configurações da aplicação."
exec "$@"

</pre>
