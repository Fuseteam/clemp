#!/bin/bash
# Executing supervisord and mysql_user
# Author : Kaushal Kishore <kaushal.rahuljaiswal@gmail.com>

if [ -z ${PASSWORD+x} ]; then
	/mysql_user.sh
fi
exec supervisord -n -c /etc/supervisord.conf
