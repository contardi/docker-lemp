#Docker LEMP + XDebug
#### Just another LEMP + XDebug Docker

You need to change the args into the docker-compose.yml files to your current user, UID and GID \
That'll enabled you to change the files with the same permissions as www-data into the php server 

* NGINX
* PHP 5.6
* PHP 7.2
* MariaDB
* PHPMyAdmin
* Mongo
* Memcached
* Mailhog
* Redis
* ElasticSearch
* RabbitMQ
* Node
* XDebug 

#### URLs
**Nginx:** http://localhost/ - Folder var/www/ \
**Node:** http://localhost:3000/ Folder var/app
**PHPMyAdmin:** http://localhost:8080/ \
**Mailhog:** http://localhost:8025/ \


#### Access PHP Servers
PHP 5.6: `docker-compose exec php56-fpm bash` \
PHP 7.2: `docker-compose exec php72-fpm bash`

#### Access Node Server
Node user: `docker-compose exec node bash`
Root user: `docker-compose exec -u root node bash`

To change default variable edit `.env`  file 
