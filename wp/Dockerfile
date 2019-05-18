FROM php:7.3-fpm-alpine
#https://raw.githubusercontent.com/docker-library/wordpress/07958d19ed465fb7fe50626be740d88a2c2260a7/php7.3/fpm-alpine/Dockerfile

# docker-entrypoint.sh dependencies
RUN apk add --no-cache \
# in theory, docker-entrypoint.sh is POSIX-compliant, but priority is a working, consistent image
		bash \
# BusyBox sed is not sufficient for some of our sed expressions
		sed

# install the PHP extensions we need
RUN set -ex; \
	\
	apk add --no-cache --virtual .build-deps \
		libjpeg-turbo-dev \
		libpng-dev \
		libzip-dev \
	; \
	\
	docker-php-ext-configure gd --with-png-dir=/usr --with-jpeg-dir=/usr; \
	docker-php-ext-install gd mysqli opcache zip; \
	\
	runDeps="$( \
		scanelf --needed --nobanner --format '%n#p' --recursive /usr/local/lib/php/extensions \
			| tr ',' '\n' \
			| sort -u \
			| awk 'system("[ -e /usr/local/lib/" $1 " ]") == 0 { next } { print "so:" $1 }' \
	)"; \
	apk add --virtual .wordpress-phpexts-rundeps $runDeps; \
	apk del .build-deps

# set recommended PHP.ini settings
# see https://secure.php.net/manual/en/opcache.installation.php
RUN { \
		echo 'opcache.memory_consumption=128'; \
		echo 'opcache.interned_strings_buffer=8'; \
		echo 'opcache.max_accelerated_files=4000'; \
		echo 'opcache.revalidate_freq=2'; \
		echo 'opcache.fast_shutdown=1'; \
		echo 'opcache.enable_cli=1'; \
	} > /usr/local/etc/php/conf.d/opcache-recommended.ini
# https://codex.wordpress.org/Editing_wp-config.php#Configure_Error_Logging
RUN { \
		echo 'error_reporting = 4339'; \
		echo 'display_errors = Off'; \
		echo 'display_startup_errors = Off'; \
		echo 'log_errors = On'; \
		echo 'error_log = /dev/stderr'; \
		echo 'log_errors_max_len = 1024'; \
		echo 'ignore_repeated_errors = On'; \
		echo 'ignore_repeated_source = Off'; \
		echo 'html_errors = Off'; \
	} > /usr/local/etc/php/conf.d/error-logging.ini

VOLUME /var/www/html

ENV WORDPRESS_VERSION 5.2-fa_IR
ENV WORDPRESS_SHA1 e5bf32c634066df4cacdb66bd1f42f15b16488ad
# http://fa.wordpress.org/wordpress-5.2-fa_IR.tar.gz

RUN set -ex;\
	curl -o wordpress.tar.gz -fSL "http://fa.wordpress.org/wordpress-${WORDPRESS_VERSION}.tar.gz"; \
        sha1sum wordpress.tar.gz; \
        echo "$WORDPRESS_SHA1 *wordpress.tar.gz" | sha1sum -c -; \
        # upstream tarballs include ./wordpress/ so this gives us /usr/src/wordpress
	tar -xzf wordpress.tar.gz -C /usr/src/; \
	rm wordpress.tar.gz; \
	chown -R www-data:www-data /usr/src/wordpress; \
        ls -l ;

RUN set -ex;\
        sed -i.orig '/^<?php/a  define("WP_HOME","/blog/"); \n define("WP_SITEURL","/blog/"); \n $_SERVER["REQUEST_URI"] = str_replace("/wp-admin/", "/blog/wp-admin/",  $_SERVER["REQUEST_URI"]); \n @ini_set( "upload_max_size" , "100M" );\n @ini_set( "post_max_size", "25M");\n @ini_set( "memory_limit", "100M" );' /usr/src/wordpress/wp-config-sample.php; 


COPY docker-entrypoint.sh /usr/local/bin/
ENTRYPOINT ["/usr/local/bin/docker-entrypoint.sh"]
CMD ["php-fpm"]
