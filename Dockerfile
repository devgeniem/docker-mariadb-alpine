FROM alpine:latest

ENV LC_ALL=en_GB.UTF-8 \
    TZ='Europe/Helsinki' \
    DATA_DIR='/data'

RUN    apk -U upgrade \
    # Install mariadb and mariadb-client
    && apk add mariadb mariadb-client \
    && mkdir /docker-entrypoint-initdb.d \
    && rm -rf /var/lib/mysql \
    # Add default timezone
    && apk add tzdata \
    && cp /usr/share/zoneinfo/${TZ} /etc/localtime \
    && echo "${TZ}" > /etc/timezone \
    # cleanup
    && rm -rf /tmp/src \
    && rm -rf /var/cache/apk/* \

    # Provide symlink for mysql for error logging
    && ln -sf /dev/stderr /var/log/mysql.err

COPY docker-entrypoint.sh /
ENTRYPOINT ["/docker-entrypoint.sh"]

COPY my.cnf /etc/mysql/my.cnf

VOLUME ${DATA_DIR}
EXPOSE 3306
