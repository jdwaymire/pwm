FROM openjdk:8-jre-alpine

LABEL maintainer="Justin Waymire <justin@waymirenet.com>"

COPY files/ /

ENV RELDATE=2020-08-20T23_36_49Z \
    ARCHIVE=pwm-onejar-2.0.0-SNAPSHOT.jar \
    PWM_PATH=/usr/share/pwm/ \
    SUPERVISOR_PATH=/run/supervisord \
    PACKAGES="supervisor wget" \
    JAVA_OPTS="-server -Xmx1g -Xms1g"

RUN apk add --update --no-cache $PACKAGES && \
    mkdir -p $PWM_PATH $SUPERVISOR_PATH && \
    cd $PWM_PATH && \
    chmod +x /usr/bin/start-pwm.sh && \
    wget https://www.pwm-project.org/artifacts/pwm/build/${RELDATE}/${ARCHIVE} && \
    apk add --no-cache nginx && \
    mkdir /tmp/nginx && \
    mkdir -p /run/nginx && \
    rm -rf /var/cache/apk/*

WORKDIR /config
VOLUME [ "/config" ]

EXPOSE 80
EXPOSE 8443
CMD ["/usr/bin/supervisord", "--nodaemon", "-c", "/etc/supervisord.conf"]
