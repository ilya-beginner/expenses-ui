FROM nginx:1.23.1
COPY html /usr/share/nginx/html

CMD \
    envsubst < /usr/share/nginx/html/index.html.tpl > /usr/share/nginx/html/index.html && \
    envsubst < /usr/share/nginx/html/view.html.tpl > /usr/share/nginx/html/view.html && \
    /usr/sbin/nginx -g "daemon off;"
