FROM linuxserver/mariadb

RUN \
  apt-get --assume-yes update && apt-get --assume-yes upgrade && \
  apt-get --assume-yes install git-core nginx php7.2-fpm php7.2-xml php7.2-mysqli php7.2-gd libace-dev

RUN \
  rm -rf /var/www/html && \
  git clone https://github.com/mangoszero/database.git /database --recursive -b master && \
  git clone https://github.com/solipsist01/MangosZero.git /install --recursive -b master
  
COPY --from=solipsist01/mangosbuild /mangos /mangos

RUN \
  mkdir /etc/services.d/mangosd && \
  mkdir /etc/services.d/realmd && \
  mkdir /etc/services.d/nginx && \
  mkdir /etc/services.d/php7.2-fpm && \
  mkdir /run/php && \
  mkdir /var/www/html && \
  cp /install/TrinityWeb/* /var/www/html -R && \
  cp /install/servicemangosd /etc/services.d/mangosd/run && \
  cp /install/servicerealmd /etc/services.d/realmd/run && \
  cp /install/servicenginx /etc/services.d/nginx/run && \
  cp /install/servicephp-fpm /etc/services.d/php7.2-fpm/run && \
  cp /install/50-prepmangos /etc/cont-init.d && \
  cp /install/60-prepmangosweb /etc/cont-init.d && \
  cp /install/nginxdefaultconfig /etc/nginx/sites-enabled/default && \
  chmod +x /install/InstallMangos.sh && \
  chmod +x /install/InstallDatabases.sh && \
  chmod +x /install/InstallWowfiles.sh && \
  chmod +x /install/UpdateWanIP.sh && \
  chmod +x /etc/cont-init.d/50-prepmangos && \
  chmod +x /etc/cont-init.d/60-prepmangosweb && \
  rm -rf /install/TrinityWeb
