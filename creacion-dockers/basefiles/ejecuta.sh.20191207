#!/bin/sh -e
sed -Ei 's/^(bind-address|log)/#&/' /etc/mysql/mysql.conf.d/mysqld.cnf
service mysql start 
mysql --defaults-extra-file=/mysqlconfig.cnf < /mysql-ssl.sql
cd /etc/apache2/mods-enabled/
ln -s ../mods-available/headers.load headers.load
apachectl -D FOREGROUND
