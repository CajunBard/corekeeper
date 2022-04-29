FROM ubuntu:focal

RUN export DEBIAN_FRONTEND noninteractive && \
    dpkg --add-architecture i386 && \
    apt-get update && \
    apt-get install -y tar lib32gcc1 curl xvfb locales && \
    echo en_US.UTF-8 UTF-8 >> /etc/locale.gen && locale-gen && \
    rm -rf /var/lib/apt/lists/*  && \
    useradd -m steam && \
    mkdir /config && \
    chown steam:steam /config

# needed for Xvfb to function
RUN mkdir /tmp/.X11-unix && chmod 1777 /tmp/.X11-unix

USER steam

ENV HOME /home/steam
ENV STEAMUSER default
ENV STEAMPWD default

VOLUME /config

WORKDIR /home/steam

RUN curl -sqL "https://steamcdn-a.akamaihd.net/client/installer/steamcmd_linux.tar.gz" | tar xz

COPY --chown=steam:steam entry.sh /home/steam/

EXPOSE 27015/udp
EXPOSE 27016/udp

CMD ["/home/steam/entry.sh"]