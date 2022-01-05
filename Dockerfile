FROM php:8.1-apache-bullseye

### Prepare the apache server
# add global servername for localhost, prevents an uncertain apache2
RUN printf 'ServerName 127.0.0.1\n' >> /etc/apache2/apache2.conf

# copy the vhost file that gives global access to /var/www/html
COPY init.php/vhost.conf /etc/apache2/sites-enabled/000-default.conf

# do an apt update and install non-interactive aids to prevent some warnings from apt
ENV DEBIAN_FRONTEND=noninteractive
RUN apt update && apt install -y \
    apt-utils \
    wget \
    libpq-dev \
    && docker-php-ext-configure pgsql -with-pgsql=/usr/local/pgsql \
    && docker-php-ext-install pdo pdo_pgsql pgsql

### Install flyspray
# Current version is v1.0-rc10/flyspray-1.0-rc10.tgz

ENV FLYSPRAY_VERSION=1.0-rc10
ENV SUB_PATH=v${FLYSPRAY_VERSION}/flyspray-${FLYSPRAY_VERSION}.tgz
ENV FLYSPRAY_DL=https://github.com/Flyspray/flyspray/releases/download/${SUB_PATH}

# download the flyspray image to /tmp
RUN wget -q -O /tmp/flyspray.tgz ${FLYSPRAY_DL}

EXPOSE 80

# test if a flyspray directory exists, if not, create it and copy the flyspray files into
CMD ["/bin/bash", "-c", \
       "if [[ ! -d /var/www/html/flyspray ]] ; \
        then \
            echo 'Extracting files...' && \
            mkdir -p /var/www/html/flyspray && \
            tar xzf /tmp/flyspray.tgz -C /var/www/html/flyspray --strip-components=1 && \
            chown -R www-data:www-data /var/www/html && \
            ls -l /var/www/html ; \
        fi && \
        /usr/sbin/apache2ctl -D FOREGROUND"]
