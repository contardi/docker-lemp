#Docker LEMP + XDebug

#### Just another multipurpose LEMP + XDebug Docker

You need to change the args into the docker-compose.yml files to your current user, UID and GID \
That'll enable you to change the files with the same permissions as www-data into the php server 

* NGINX
* PHP 5.6
* XDebug
* MariaDB 10.4 (Magento 2 compatibility)
* PHPMyAdmin
* Memcached
* Mailhog
* Redis

#### URLs
**Nginx:** http://localhost/ - Folder var/www/  
**PHPMyAdmin:** http://localhost:8000/  
**Mailhog:** http://localhost:8025/  

#### Access PHP Servers  
PHP 5.6: `docker compose exec php56-fpm bash` 
NGINX: `docker compose exec webserver sh`  
MariaDB: `docker compose exec mariadb bash`

#### Logs
./var/logs/php_errors.log
./var/logs/mysql/mysql.log

To change default variables, edit `.env`  file 

This is just a multipurpose repository intended to developer who need in a same environment PHP 5.6 within other PHP versions.
