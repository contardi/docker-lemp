#Docker LEMP + XDebug

### Just another multipurpose LEMP + XDebug Docker

This version uses MySQL, if you need a version with MariaDB it's possible use the v1.0  
Don't forget to change the .env to your current user

* NGINX
* VARNISH (Configured for Magento 2)
* PHP 7.4
* PHP 8.1
* PHP 8.2 (latest)
* XDebug 3
* MySQL 8
* PHPMyAdmin
* Mongo
* Mailhog
* Redis
* OpenSearch
* RabbitMQ
* SonarQube
* Node (LTS)

To change default variables, edit `.env`  file

### URLs
**Nginx:** http://localhost/ - Folder var/www/  
**Node:** http://localhost:3000/ Folder var/app    
**PHPMyAdmin:** http://localhost:8000/  
**Mailhog:** http://localhost:8025/  
**OpenSearch Dashoboards (Kibana)** http://localhost:5601/  
**SonarQube:** http://localhost:9999/ | admin:admin  
**RabbitMQ:** http://localhost:15672/ | rabbitmq:rabbitmq  

### Logs
PHP: ./var/log/php{VERSION}/php_errors.log  
MySQL: ./var/log/mysql/mysql.log  
Mongo: ./var/log/mongo/mongodb.log  

### Scripts   
The `shell/` folder has some scripts to help development, mostly for Magento but also for other sites
In order to use Magento script, it's necessary to edit `shell/.env` file  and it's necessary to have mysql-client installed on host machine  
All command must be executed from host on docker root folder  
  
#### Magento 2 scripts
- `shell/m2-create-empty.sh store.local` - create a new magento store
- `shell/m2-clear-cache.sh store.local` - clear cache 
- `shell/m2-clear-processed.sh store.local` - clear view/processed 
- `shell/m2-indexer.sh store.local` - index store
- `shell/m2-update.sh store.local` - Upgrade store with setup upgrade, di:compile 
- `shell/m2-update-git.sh store.local` - Iterate from app/code folder and app/design to run a git pull on each folder 

#### General scripts
- `shell/create-site.sh site.local` - create an empty site with database and vhost 
- `shell/create-site.sh site.local` - remove a site with his files, database and vhost 

 
