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
    /usr/sbin/sshd -D"]

RUN export DEBIAN_FRONTEND=noninteractive \
    && apt-get update && apt-get install -y gnupg2 wget locales locales-all \
    && wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add -  \
    && echo "deb https://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google.list \
    && apt-get update && apt-get install -y openssh-server htop nano cron mc psmisc curl git python3-pip google-chrome-stable \
    && rm -f /etc/apt/sources.list.d/google.list \
    && pip3 install virtualenv \
    && mkdir -p /var/run/sshd \
    && sed -i "s/UsePrivilegeSeparation.*/UsePrivilegeSeparation no/g" /etc/ssh/sshd_config \
    && sed -i 's/PermitRootLogin without-password/PermitRootLogin yes/' /etc/ssh/sshd_config \
    && touch /root/.Xauthority \
    && apt-get install -f -y
