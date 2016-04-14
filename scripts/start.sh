#!/bin/bash

mkdir -p -m 0700 /root/.ssh
echo -e "Host *\n\tStrictHostKeyChecking no\n" >> /root/.ssh/config

if [ ! -z "$DEBS" ]; then
 apt-get update
 apt-get install -y $DEBS
fi

if [[ "$ERRORS" != "1" ]] ; then
  sed -i -e "s/error_reporting =.*=/error_reporting = E_ALL/g" /etc/php5/fpm/php.ini
  sed -i -e "s/display_errors =.*/display_errors = On/g" /etc/php5/fpm/php.ini
fi

procs=$(cat /proc/cpuinfo |grep processor | wc -l)
sed -i -e "s/worker_processes 5/worker_processes $procs/" /etc/nginx/nginx.conf

if [[ "$TEMPLATE_NGINX_HTML" == "1" ]] ; then
  for i in $(env)
  do
    variable=$(echo "$i" | cut -d'=' -f1)
    value=$(echo "$i" | cut -d'=' -f2)
    if [[ "$variable" != '%s' ]] ; then
      replace='\$\$_'${variable}'_\$\$'
      find /usr/share/nginx/html -type f -exec sed -i -e 's/'${replace}'/'${value}'/g' {} \;
    fi
  done
fi

if [ ! -f /usr/share/nginx/html/LocalSettings.php  ]; then 
  cd ~ && \
  curl -O https://releases.wikimedia.org/mediawiki/1.23/mediawiki-1.23.13.tar.gz && \
  tar xvzf mediawiki-*.tar.gz && \
  mv mediawiki-1.23.13/* /usr/share/nginx/html/ && \
  rm mediawiki-1.23.13 -Rf && \
  rm mediawiki-*.tar.gz  
fi

chown -Rf www-data.www-data /usr/share/nginx/html/

/usr/bin/supervisord -n -c /etc/supervisord.conf