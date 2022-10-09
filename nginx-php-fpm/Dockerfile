FROM php:8.1-fpm as phpfpmbase

ENV COMPOSER_MEMORY_LIMIT='-1'

ARG RUN_LARAVEL_SCHEDULER=false
ARG ARG_COMPOSER_INSTALL=false
ARG ARG_NPM_INSTALL=false

ARG ARG_NGINX_PORT="80"

ENV NGINX_PORT="${ARG_NGINX_PORT}"


RUN apt-get update && \
    apt-get install -y --force-yes --no-install-recommends \
        libmemcached-dev \
        libzip-dev \
        libz-dev \
        libzip-dev \
        libpq-dev \
        libjpeg-dev \
        libpng-dev \
        libfreetype6-dev \
        libssl-dev \
        openssh-server \
        libmagickwand-dev \
        git \
        cron \
        nano \
        libxml2-dev \
        libreadline-dev \
        libgmp-dev \
        mariadb-client \
        unzip

# Install soap extention
RUN docker-php-ext-install \
    soap \
    exif \
    pcntl \
    zip \
    pdo_mysql \
    pdo_pgsql \
    bcmath \
    intl \
    gmp

#####################################
# PHPRedis:
#####################################
RUN pecl install redis && docker-php-ext-enable redis

#####################################
# Imagick:
#####################################

RUN pecl install imagick && \
    docker-php-ext-enable imagick

#####################################
# GD:
#####################################
RUN docker-php-ext-install gd && \
    docker-php-ext-configure gd --with-freetype --with-jpeg && \
    docker-php-ext-install gd

#####################################
# xDebug:
#####################################
RUN pecl install xdebug

#####################################
# PHP Memcached:
#####################################
RUN pecl install memcached && docker-php-ext-enable memcached

#####################################
# Composer:
#####################################

# Install composer and add its bin to the PATH.
RUN curl -s http://getcomposer.org/installer | php && \
    echo "export PATH=${PATH}:/var/www/vendor/bin" >> ~/.bashrc && \
    mv composer.phar /usr/local/bin/composer
# Source the bash
RUN . ~/.bashrc

#####################################
# Laravel Schedule Cron Job:
#####################################
RUN echo "* * * * * www-data /usr/local/bin/php /var/www/artisan schedule:run >> /dev/null 2>&1"  >> /etc/cron.d/laravel-scheduler
RUN chmod 0644 /etc/cron.d/laravel-scheduler


#######################################
# install nginx
#######################################
RUN apt-get install nginx -y
RUN apt-get install gettext-base
COPY ./templates/default.conf.template /etc/nginx/templates/default.conf.template

## map nginx logs to stdout/stderr
RUN ln -sfT /proc/self/fd/2 /var/log/nginx/error.log; \
	ln -sfT /proc/self/fd/1 /var/log/nginx/access.log; 



#######################################
# install supervisor
#######################################
RUN apt-get install supervisor -y
ADD conf/supervisord.conf /etc/supervisord.conf


RUN rm -r /var/lib/apt/lists/*

RUN usermod -u 1000 www-data



COPY ./sample_webapp/ /var/www/html/

#COPY . /var/www/html
#RUN composer install --no-interaction --prefer-dist --optimize-autoloader
#RUN npm install -y
#RUN npm run production
#RUN php artisan clear-compiled && php artisan route:cache && php artisan view:cache


ADD ./laravel.ini /usr/local/etc/php/conf.d

ADD ./docker-entrypoint.sh /
RUN chmod +x /docker-entrypoint.sh
ENTRYPOINT ["/docker-entrypoint.sh"]

WORKDIR /var/www/html

EXPOSE 443 80 9000

CMD ["/usr/bin/supervisord",  "-n",  "-c",  "/etc/supervisord.conf"]
