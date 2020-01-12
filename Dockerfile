FROM debian:stable

LABEL maintainer="Michael Fessenden <michael@mikefez.com>"

ENV ADDITIONAL_APT=
ENV PUID="1000"
ENV PGID="1000"

ENTRYPOINT ["/bin/bash", "-c"]

CMD ["echo \"===== Startup Tasks =====\" && \
    if ! [[ -z \"$ADDITIONAL_APT\" ]]; then \
        echo \"Preparing to add additional apk [${ADDITIONAL_APT}]\" && \
        clean_list=$( echo \"${ADDITIONAL_APT}\" | tr ',' ' ') && \
        echo \"Executing: apt-get install -y ${clean_list}\" && \
        apt-get install -y ${clean_list} ; \
    fi && \
    tail -f /dev/null"]

RUN export DEBIAN_FRONTEND=noninteractive; \
    apt-get update && apt-get install -y gnupg2 wget locales locales-all ; \
    wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add -  && \
    echo "deb https://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google.list && \
    apt-get update && apt-get install -y openssh-server htop nano cron mc psmisc curl git python3-pip google-chrome-stable && \
    service ssh start && \
    rm -f /etc/apt/sources.list.d/google.list && \
    pip3 install virtualenv && \
    apt-get install -f -y
