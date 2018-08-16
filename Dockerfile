FROM php:7.2-fpm

ENV COMPOSER_ALLOW_SUPERUSER 1

RUN apt-get update && \
    apt-get -y install \
        sudo \
        libicu57 \
        libicu-dev \
        libpq-dev \
        zlib1g-dev \
        libssh2-1-dev \
        libfreetype6-dev \
        libjpeg62-turbo-dev \
        libmcrypt-dev \
        libpng-dev \
        --no-install-recommends

# Required extension
RUN pecl install apcu-5.1.8 && \
    docker-php-ext-enable apcu && \
    git clone https://github.com/php/pecl-networking-ssh2.git /usr/src/php/ext/ssh2 && \
    docker-php-ext-configure pgsql -with-pgsql=/usr/local/pgsql && \
    docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/ && \
    docker-php-ext-install -j$(nproc) \
        intl \
        opcache \
        mbstring \
        zip \
        ssh2 \
        pdo \
        pdo_pgsql \
        pgsql \
        bcmath \
        gd \
    && \
    apt-mark manual libpq5

# Cleanup to keep the images size small
RUN apt-get purge -y \
        icu-devtools \
        libicu-dev \
    && \
    apt-get autoremove -y && \
    rm -r /var/lib/apt/lists/*
