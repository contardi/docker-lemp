#Docker LEMP + XDebug

### Just another multipurpose LEMP + XDebug Docker

This version uses MySQL, if you need a version with MariaDB it's possible use the v1.0  
Don't forget to change the .env to your current user

* NGINX
* PHP 5.6
* PHP 7.4
* PHP 8.1
* PHP 8.2 (latest)
* XDebug 3
* MySQL 8
* PHPMyAdmin
* Mongo
* Memcached
* Mailhog
* Redis
* OpenSearch
* RabbitMQ
* SonarQube
* TeamCity (CI by JetBrains)
* Node (LTS)

### URLs
**Nginx:** http://localhost/ - Folder var/www/  
**Node:** http://localhost:3000/ Folder var/app    
**PHPMyAdmin:** http://localhost:8000/  
**Mailhog:** http://localhost:8025/  
**OpenSearch Dashoboards (Kibana)** http://localhost:5601/  
**SonarQube:** http://localhost:9000/ | admin:admin  
**TeamCity:** http://localhost:8111/  (JetBrains CI)  

### Logs
PHP: ./var/log/php{VERSION}/php_errors.log  
MySQL: ./var/log/mysql/mysql.log  
Mongo: ./var/log/mongo/mongodb.log  
TeamCity: ./var/log/teamcity/  

To change default variables, edit `.env`  file 
