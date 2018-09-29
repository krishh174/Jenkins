FROM php:7.3-rc-apache
LABEL maintainer='krishh11234@gmail.com'
LABEL name='my-php-app'
COPY src/ /var/www/php
EXPOSE 80
