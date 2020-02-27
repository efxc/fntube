FROM alpine
RUN apk add --no-cache apache2 perl \
	perl-cgi perl-json-xs perl-libwww  \
	perl-lwp-protocol-https
COPY httpd.conf /etc/apache2/httpd.conf
COPY src /usr/lib/cgi-bin
RUN chmod 755 -R /usr/lib/cgi-bin
EXPOSE 80
RUN adduser -D f4nk
RUN chown f4nk /usr/lib/cgi-bin
RUN chmod a+rwx /usr/lib/cgi-bin -R
USER f4nk
CMD httpd -DFOREGROUND -C "Listen $PORT"
