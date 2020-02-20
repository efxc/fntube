FROM alpine
RUN apk add --no-cache apache perl \
	perl-cgi perl-json-xs perl-libwww  \
	perl-lwp-protocol-https
COPY conf/httpd.conf /etc/apache2/httpd.conf
COPY src /usr/lib/cgi-bin
EXPOSE 80
CMD ["httpd", "-D", "FOREGROUND"]
