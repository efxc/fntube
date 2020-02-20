FROM alpine
RUN apk add --no-cache apache-mod-fcgid \
	perl-cgi perl-fcgi perl-libwww  \
	perl-utils
RUN cpan -T Module::Build Cache::File
COPY . /usr/lib/cgi-bin
EXPOSE 80
CMD ["httpd", "-D", "FOREGROUND"]
