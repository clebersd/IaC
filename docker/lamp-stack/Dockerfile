FROM debian:trixie-backports

ARG DEBIAN_FRONTEND=nointeractive

VOLUME [ "/home/lamp" ]

ENV HOME=/home/lamp 

WORKDIR $HOME


RUN apt update && apt upgrade -y 

RUN echo "phpmyadmin phpmyadmin/reconfigure-webserver multiselect apache2" | debconf-set-selections && \
    echo "phpmyadmin phpmyadmin/dbconfig-install boolean false" | debconf-set-selections

RUN mkdir -p /run/mysqld 

RUN apt install apache2 mariadb-server php php-mysql phpmyadmin -y

RUN echo "ServerName localhost" >> /etc/apache2/apache2.conf

ENV MYSQL_ROOT_PASSWORD=1234567

COPY ./script.sh $HOME/script.sh 

RUN chmod +x $HOME/script.sh


ENTRYPOINT ["/home/lamp/script.sh"] 

EXPOSE 80 3306

#Pendente ajustar o usuario de login na base mysql 




