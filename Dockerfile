FROM nginx:1.23.1

COPY html /usr/share/nginx/html

CMD \
    envsubst < /usr/share/nginx/html/constants.js.tpl > /usr/share/nginx/html/constants.js && \
    /usr/sbin/nginx -g "daemon off;"
