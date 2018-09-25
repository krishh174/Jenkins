FROM php:7.3-rc-apache
COPY src/ /var/www/html
EXPOSE 80
