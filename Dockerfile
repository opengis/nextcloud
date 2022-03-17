FROM nextcloud:23.0.2

RUN apt-get update \
    && apt-get install -y libmagickcore-6.q16-6-extra supervisor libc-client-dev libkrb5-dev libgmp3-dev ffmpeg libreoffice libbz2-dev \
    && apt-get -y autoremove \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

RUN docker-php-ext-install bz2 \
    && docker-php-ext-configure imap --with-kerberos --with-imap-ssl \
    && docker-php-ext-install imap \
    && docker-php-ext-install gmp

RUN mkdir -p /var/log/supervisord
RUN mkdir -p /var/run/supervisord

RUN sed -i "s/opcache.interned_strings_buffer=8/opcache.interned_strings_buffer=16/g" /usr/local/etc/php/conf.d/opcache-recommended.ini |grep opcache.interned_strings_buffer /usr/local/etc/php/conf.d/opcache-recommended.ini

COPY supervisord.conf /etc/supervisor/supervisord.conf

CMD ["/usr/bin/supervisord"]
