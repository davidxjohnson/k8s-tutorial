FROM nginx:mainline-alpine
EXPOSE 80/tcp
RUN rm /etc/nginx/conf.d/*
ADD hello.conf /etc/nginx/conf.d/
ADD index.html /usr/share/nginx/html/
