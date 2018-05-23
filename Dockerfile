FROM php:fpm-alpine3.7

RUN apk --update add wget \
  curl \
  git \
  grep \
  nginx \
  build-base \
  libmemcached-dev \
  libmcrypt-dev \
  libxml2-dev \
  zlib-dev \
  autoconf \
  cyrus-sasl-dev \
  libgsasl-dev \
  supervisor \
  re2c \
  openssl

RUN docker-php-ext-install mysqli mbstring pdo pdo_mysql tokenizer xml opcache

# install igbinary 
RUN cd /tmp && \
    wget https://github.com/igbinary/igbinary/archive/2.0.6.zip && \
    unzip 2.0.6.zip && cd igbinary-2.0.6 && \
    phpize && ./configure && make && make install && \
    docker-php-ext-enable igbinary

# install memcached 
RUN cd /tmp && \
    wget https://github.com/php-memcached-dev/php-memcached/archive/v3.0.4.zip && \
    unzip v3.0.4.zip && cd php-memcached-3.0.4 && \
    phpize && ./configure --enable-memcached-igbinary && make && make install && \
    docker-php-ext-enable memcached

RUN cd /tmp && \
    wget https://github.com/phpredis/phpredis/archive/4.0.2.zip && \
    unzip 4.0.2.zip && cd phpredis-4.0.2 && \
    phpize && ./configure --enable-redis-igbinary && make && make install && \
    docker-php-ext-enable redis

# clean up and create www
RUN rm /var/cache/apk/* && \
    mkdir -p /var/www && \
    rm -rf /tmp/*

# copy service configs and files 

EXPOSE 9000

ENTRYPOINT ["php-fpm"]
