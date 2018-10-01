FROM ubuntu:16.04
LABEL MAINTAINER="krishh11234@gmail.com" \
      name="php-app"
WORKDIR /
RUN apt-get -y update && apt-get install -y php7.0 && apt-get install -y libapache2-mod-php7.0 
ENV USER="php"
CMD apachectl -D FOREGROUND
RUN rm /var/www/html/index.html
WORKDIR /home/$USER
COPY src/ /var/www/html
EXPOSE 80
