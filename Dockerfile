FROM php:7.0-fpm

MAINTAINER KENDRICK/MEDIA.figaro <media.figaro@gmail.com>
LABEL DESCRIPTION "PHP7-FPM Docker container optimized for Symfony with OPcache and graphic library"
LABEL version="1.0"

RUN apt-get update && apt-get install -y \

    git \
    unzip \

    # GD dependencies

    libfreetype6-dev \
    libjpeg62-turbo-dev \
    libpng12-dev \
    # webp
    libvpx-dev \

    # Type docker-php-ext-install to see available extensions

    && docker-php-ext-install pdo_mysql opcache \

    # GD configure

    && docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/ --with-png-dir=/usr/include/ --with-vpx-dir=/usr/include/ \
    && docker-php-ext-install gd

# opcache

RUN { \
		echo 'opcache.memory_consumption=128'; \
		echo 'opcache.interned_strings_buffer=8'; \
		echo 'opcache.max_accelerated_files=4000'; \
		echo 'opcache.revalidate_freq=60'; \
		echo 'opcache.fast_shutdown=1'; \
		echo 'opcache.enable_cli=1'; \
	} > /usr/local/etc/php/conf.d/opcache-recommended.ini

RUN echo "realpath_cache_size = 4096k; realpath_cache_ttl = 7200;" > /usr/local/etc/php/conf.d/php.ini

# composer

RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer && \
    composer --version

# timezone

RUN rm /etc/localtime && \
    ln -s /usr/share/zoneinfo/Europe/Paris /etc/localtime && \
    "date"

RUN echo 'alias sf2="php app/console"' >> ~/.bashrc
RUN echo 'alias sf="php bin/console"' >> ~/.bashrc
