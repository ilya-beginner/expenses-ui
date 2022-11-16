FROM nginx:1.23.1

COPY html /usr/share/nginx/html

CMD \
    envsubst < /usr/share/nginx/html/index.html.tpl > /usr/share/nginx/html/index.html && \
    /usr/sbin/nginx -g "daemon off;"
