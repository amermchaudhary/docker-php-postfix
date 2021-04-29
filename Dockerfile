FROM alpine:3.10

COPY php.ini /etc/php7/conf.d/nodesol.ini
COPY entrypoint /usr/bin/entrypoint
COPY nginx.conf /etc/nginx/conf.d/default.conf

RUN apk update \
	&& apk upgrade \
	&& apk add nginx postfix curl cyrus-sasl cyrus-sasl-plain cyrus-sasl-login \
	&& apk add php7 php7-cli php7-fpm php7-bcmath php7-phar php7-tokenizer php7-curl php7-json php7-openssl php7-zip php7-pdo php7-mysqli php7-pdo_mysql php7-mysqlnd php7-dom php7-mbstring php7-session php7-fileinfo php7-gd php7-mcrypt php7-calendar \
	&& ln -s /usr/sbin/php-fpm7 /usr/bin/php-fpm \
	&& nginx -v && php -v && php-fpm -v \
	&& mkdir -p /run/nginx \
	&& mkdir -p /home/nodesol/public \
	&& chmod -R 777 /home/nodesol/public \
	&& chmod a+x /usr/bin/entrypoint


####
# POSTFIX
####

#RUN mv /etc/postfix/main.cf /etc/postfix/main.cf.BAK

COPY postfix/main.cf /etc/postfix/main.cf
COPY postfix/sasl_passwd /etc/postfix/sasl_passwd

RUN postmap hash:/etc/postfix/sasl_passwd \
	&& touch /etc/postfix/virtual \
	&& postmap /etc/postfix/virtual \
	&& touch /etc/postfix/aliases \
	&& postmap hash:/etc/postfix/aliases \
	&& chown root:postdrop /usr/sbin/postdrop \
	&& chmod 2755 /usr/sbin/postdrop

EXPOSE 80

CMD exec /usr/bin/entrypoint
