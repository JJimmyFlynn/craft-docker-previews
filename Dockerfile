FROM craftcms/php-fpm:8.1

ARG NGINX_CONF=default.conf

# install supervisor and nginx
USER root
RUN apk update --no-cache && apk add --no-cache supervisor nginx
COPY supervisor.conf /etc/supervisor/conf.d/supervisor.conf
COPY nginx.conf /etc/nginx/nginx.conf
COPY craftcms/general.conf /etc/nginx/craftcms/
COPY craftcms/php_fastcgi.conf /etc/nginx/craftcms/
COPY craftcms/security.conf /etc/nginx/craftcms/
COPY ${NGINX_CONF} /etc/nginx/conf.d/default.conf
RUN touch /run/nginx.pid
RUN touch /run/supervisord.pid
RUN chown www-data /run/nginx.pid
RUN chown www-data /run/supervisord.pid
RUN chown -R www-data:www-data /var/lib/nginx/logs/
COPY app /app
RUN chown -R www-data:www-data /app
USER www-data

EXPOSE 80
ENTRYPOINT ["/usr/bin/supervisord", "-c", "/etc/supervisor/conf.d/supervisor.conf"]
