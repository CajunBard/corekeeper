FROM ubuntu:focal

RUN export DEBIAN_FRONTEND noninteractive && \
    dpkg --add-architecture i386 && \
    apt-get update && \
    apt-get install -y net-tools tar unzip lib32gcc1 curl xz-utils gnupg2 software-properties-common xvfb libc6:i386 locales && \
    echo en_US.UTF-8 UTF-8 >> /etc/locale.gen && locale-gen && \
    rm -rf /var/lib/apt/lists/*  && \
    useradd -m steam && \
    mkdir /config && \
    chown steam:steam /config

USER steam
ENV HOME /home/steam
WORKDIR /home/steam
VOLUME /config

RUN curl -sqL "https://steamcdn-a.akamaihd.net/client/installer/steamcmd_linux.tar.gz" | tar xz

COPY --chown=steam:steam entry.sh /home/steam/

# Get's killed at the end
RUN ./steamcmd.sh +login anonymous +quit || :
USER root
RUN mkdir /tmp/.X11-unix && chmod 1777 /tmp/.X11-unix

ENV STEAMUSER default
ENV STEAMPWD default

EXPOSE 27015/udp
EXPOSE 27016/udp

USER steam

CMD ["/home/steam/entry.sh"]