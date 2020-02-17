############################################################
# Dockerfile to build Centos-LEMP installed  Container
# Based on CentOS
############################################################

# Set the base image to CentOS
FROM centos:7

# File Author / Maintainer
MAINTAINER Fuseteam <fusekai@outlook.com>

# Add the ngix and PHP dependent repository
ADD etc/nginx.repo /etc/yum.repos.d/nginx.repo

# Installing nginx
RUN yum -y install nginx

# Installing MariaDB
RUN yum -y install mariadb-server mariadb-client

# Installing PHP
RUN yum -y install epel-release yum-utils
RUN yum -y install http://rpms.remirepo.net/enterprise/remi-release-7.rpm
RUN yum -y --enablerepo=remi,remi-php73 install nginx php-fpm php-common
RUN yum -y --enablerepo=remi,remi-php73 install php-cli php-pear php-pdo php-mysqlnd php-pgsql php-gd php-mbstring php-mcrypt php-xml php-intl

# Installing supervisor
RUN yum install -y python-setuptools
#https://pip.pypa.io/en/latest/development/release-process/#python-2-support
RUN easy_install pip
RUN pip install supervisor

# Enviroment variable for setting the Username and Password of MySQL
ENV MYSQL_ROOT_PASS root

# Adding the configuration file of the nginx
ADD etc/nginx.conf /etc/nginx/nginx.conf
ADD etc/default.conf /etc/nginx/conf.d/default.conf
# Adding the configuration file of the mysql
ADD etc/my.cnf /etc/mysql/my.cnf
# Adding the configuration file of the php fpm
ADD etc/php-fpm.conf /etc/php-fpm.conf

# Remove pre-installed database
RUN rm -rf /var/lib/mysql/*

# Add MySQL utils
ADD mysql_user.sh /mysql_user.sh
ADD run.sh /run.sh
RUN chmod 755 /*.sh

# Creating run directory php-fpm
RUN mkdir /run/php-fpm/

## Starting MySQL Service
CMD ["mysqld"]

# Adding the configuration file of the Supervisor
ADD etc/supervisord.conf /etc/

# Adding the default file
ADD www /var/www

# Add volumes for MySQL
VOLUME  ["/etc/mysql", "/var/lib/mysql" ]

# Set the port to 80
EXPOSE 80 3306

## Executing supervisord
CMD ["/run.sh"]
