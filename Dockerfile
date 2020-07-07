#version: amiryus_chpw:v1
#Postgresql with pg_cron, pg_hint, postgis and data wrapers
#tds_fdw, mysql_fdw, oracle_fdw, pg_cron, pg_hint, postgis

FROM postgres:11.4

# Use proxy, if you build it behind closed-network
ENV http_proxy=""
ENV https_proxy=""
RUN export http_proxy=""
RUN export https_proxy=""

RUN echo "alias ll='ls -lah'" >> /root/.bashrc
RUN buildDependencies="ca-certificates \
    libsybdb5 \
    freetds-dev \
    freetds-common \
    freetds-bin \
    wget \
    gcc \
    unzip \
    vim \
    make \
    cron \
    postgresql-server-dev-$PG_MAJOR \
    git" \
###################
# tds_fdw_install #
###################
  && apt-get update \
  && apt-get install -y ${buildDependencies} \
  && wget https://github.com/tds-fdw/tds_fdw/archive/master.zip \
  && unzip master.zip \
  && cd tds_fdw-master \
  && make USE_PGXS=1 \
  && make USE_PGXS=1 install \
  && sed -i '/# TDS protocol version/a \\ttds version=7.0' /etc/freetds/freetds.conf

######################
#  mysql_fdw_install #
######################

RUN apt-get -y install default-libmysqlclient-dev && \
  git clone https://github.com/EnterpriseDB/mysql_fdw.git && \
  cd mysql_fdw && make USE_PGXS=1 && make USE_PGXS=1 install && \
  cd .. && rm -R mysql_fdw

######################
# oracle_fdw_install #
######################

COPY oracle.zip /root/oracle.zip
RUN cd /root \
    && unzip oracle.zip 
RUN apt-get install -y alien \
    && alien -i /root/oracle-instantclient19.3-basic-19.3.0.0.0-1.x86_64.rpm \ 
    && alien -i /root/oracle-instantclient19.3-devel-19.3.0.0.0-1.x86_64.rpm \ 
    && alien -i /root/oracle-instantclient19.3-jdbc-19.3.0.0.0-1.x86_64.rpm  \
    && alien -i /root/oracle-instantclient19.3-odbc-19.3.0.0.0-1.x86_64.rpm  \
    && alien -i /root/oracle-instantclient19.3-sqlplus-19.3.0.0.0-1.x86_64.rpm \
    && alien -i /root/oracle-instantclient19.3-tools-19.3.0.0.0-1.x86_64.rpm 

RUN echo "/usr/lib/oracle/19.3/client64/lib/" >> /etc/ld.so.conf.d/oracle.conf \
    && ldconfig 

RUN git clone https://github.com/laurenz/oracle_fdw.git \
    && cd oracle_fdw \
    && make \
    && make install \
    && apt-get install libaio1
 
###################
# pg_cron_install #
###################
#https://github.com/citusdata/pg_cron
RUN apt-get -y install postgresql-11-cron

########################
# pg_hint_plan_install #
########################
RUN wget https://osdn.net/projects/pghintplan/downloads/72397/pg_hint_plan11-1.3.5-1.el7.x86_64.rpm
RUN alien pg_hint_plan11-1.3.5-1.el7.x86_64.rpm \
    && dpkg --install pg-hint-plan11_1.3.5-2_amd64.deb
RUN rm pg_hint_plan11-1.3.5-1.el7.x86_64.rpm \
    && rm pg-hint-plan11_1.3.5-2_amd64.deb
RUN mv /usr/pgsql-11/lib/pg_hint_plan.so /usr/lib/postgresql/11/lib/

###################
# postgis_install #
###################
RUN apt-get install postgis postgresql-11-postgis-2.5 -y

# Execute SQL_scripts 
COPY pg-extension-init.sql /docker-entrypoint-initdb.d/

## add to postgresql.conf:
RUN echo "shared_preload_libraries = 'pg_cron, pg_stat_statements, pg_hint_plan'" >> /var/lib/postgresql/data/postgresql.conf \
    && echo "cron.database_name = 'postgres'"  >> /var/lib/postgresql/data/postgresql.conf

# Disable proxy

ENV http_proxy=""
ENV https_proxy=""
RUN export http_proxy=""
