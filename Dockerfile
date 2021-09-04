FROM linuxserver/mariadb:version-110.4.21mariabionic AS builder

USER root

RUN \
  apt-get --assume-yes update && apt-get --assume-yes upgrade && \
  apt-get --assume-yes install build-essential gcc g++ automake git-core autoconf make patch \
  libmysql++-dev libtool libssl-dev grep binutils zlibc libc6 libbz2-dev cmake subversion \
  libboost-all-dev mysql-client-5.6 screen libace-dev 

RUN \
  git clone https://github.com/mangoszero/server.git /sources --recursive -b master && \
  git clone https://github.com/mangoszero/database.git /database --recursive -b master && \
  git clone https://github.com/solipsist01/MangosZero.git /install --recursive -b master

RUN \
  cd "/sources/linux" && \
  cmake .. -DDEBUG=0 -DUSE_STD_MALLOC=1 -DACE_USE_EXTERNAL=1 -DPOSTGRESQL=0 \
  -DBUILD_TOOLS=1 -DSCRIPT_LIB_ELUNA=1 -DSCRIPT_LIB_SD3=1 -DSOAP=0 -DPLAYERBOTS=1 \
  -DCMAKE_INSTALL_PREFIX="/mangos" && \
make

RUN \
  mkdir /mangos && \
  cp /sources/linux/src/tools/Extractor_projects/mmap-extractor /mangos && \
  cp /sources/linux/src/tools/Extractor_projects/map-extractor /mangos && \
  cp /sources/linux/src/tools/Extractor_projects/vmap-extractor /mangos && \
  cp /sources/linux/src/mangosd/mangosd /mangos && \
  cp /sources/linux/src/realmd/realmd /mangos 


FROM linuxserver/mariadb:version-110.4.21mariabionic

RUN \
  apt-get --assume-yes update && apt-get --assume-yes upgrade && \
  apt-get --assume-yes install git-core nginx php7.2-fpm php7.2-xml php7.2-mysqli php7.2-gd libace-dev

RUN \
  rm -rf /var/www/html && \
  git clone https://github.com/mangoszero/database.git /database --recursive -b master && \
  git clone https://github.com/solipsist01/MangosZero.git /install --recursive -b master
  
COPY --from=builder /mangos /mangos

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
