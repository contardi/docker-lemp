#Docker LEMP + XDebug
#### Just another LEMP + XDebug Docker

You need to change the args into the docker-compose.yml files to your current user, UID and GID \
That'll enable you to change the files with the same permissions as www-data into the php server 

* NGINX
* PHP 5.6
* PHP 7.4
* PHP 8.1 (latest)
* XDebug
* MariaDB 10.4 (Magento 2 compatibility)
* PHPMyAdmin
* Mongo
* Memcached
* Mailhog
* Redis
* OpenSearch
* RabbitMQ
* Node (LTS)

#### URLs
**Nginx:** http://localhost/ - Folder var/www/  
**Node:** http://localhost:3000/ Folder var/app    
**PHPMyAdmin:** http://localhost:8080/  
**Mailhog:** http://localhost:8025/  
**OpenSearch Dashoboards (Kibana)** http://localhost:5601/  

#### Access PHP Servers  
PHP 5.6: `docker-compose exec php56-fpm bash`  
PHP 7.4: `docker-compose exec php74-fpm bash`  
PHP 8.1: `docker-compose exec php-fpm bash`  

#### Access Node Server
Node user: `docker-compose exec node bash`  
Root user: `docker-compose exec -u root node bash`

To change default variables, edit `.env`  file 

This is just a multipurpose repository intended to developer who need in a same envorinment PHP 5.6 within other PHP versions.
