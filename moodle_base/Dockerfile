## Roughly based on https://github.com/jda/docker-moodle/

FROM ubuntu:18.04
LABEL maintainer="racm@live.cl"
ADD ./foreground.sh /etc/apache2/foreground.sh
ENV DEBIAN_FRONTEND="noninteractive"
RUN apt-get update && \
    apt-get install -y \ 
    vim \
    apache2 \
    curl \
    php \
    libapache2-mod-php \
    php7.2-curl \
    php7.2-mysql \
    php7.2-xml \
    php7.2-xmlrpc \
    php7.2-zip \
    php7.2-soap \
    php7.2-mbstring \
    postfix \
    pwgen \
    supervisor \
    unzip \
    wget && \
    rm -f /var/www/html/index.html && \
    cd /tmp && \
    wget https://download.moodle.org/download.php/direct/stable39/moodle-latest-39.tgz && \
    tar -xf moodle-latest-39.tgz && \
    mv /tmp/moodle/* /var/www/html/ && \
    chown -R www-data:www-data /var/www/html && \
    chmod +x /etc/apache2/foreground.sh
