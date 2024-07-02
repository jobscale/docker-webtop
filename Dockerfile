FROM ghcr.io/linuxserver/baseimage-kasmvnc:debianbookworm

# set version label
ARG BUILD_DATE
ARG VERSION
LABEL build_version="Linuxserver.io version:- ${VERSION} Build-date:- ${BUILD_DATE}"
LABEL maintainer="thelamer"

# title
ENV TITLE="Debian KDE"

RUN \
  echo "**** add icon ****" && \
  curl -o \
    /kclient/public/icon.png \
    https://raw.githubusercontent.com/linuxserver/docker-templates/master/linuxserver.io/img/webtop-logo.png && \
  echo "**** install packages ****" && \
  apt-get update && \
  DEBIAN_FRONTEND=noninteractive \
  apt-get install -y --no-install-recommends \
    wget libu2f-udev fonts-liberation \
    dolphin \
    gwenview \
    kde-config-gtk-style \
    kdialog \
    kfind \
    khotkeys \
    kio-extras \
    knewstuff-dialog \
    konsole \
    ksystemstats \
    kwin-addons \
    kwin-x11 \
    kwrite \
    plasma-desktop \
    plasma-workspace \
    qml-module-qt-labs-platform \
    systemsettings && \
  echo "**** application tweaks ****" && \
  curl -sLO "https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb" \
  apt install -y ./google-chrome-stable_current_amd64.deb \
  rm google-chrome-stable_current_amd64.deb \
  echo "**** kde tweaks ****" && \
  sed -i \
    's/applications:org.kde.discover.desktop,/applications:org.kde.konsole.desktop,/g' \
    /usr/share/plasma/plasmoids/org.kde.plasma.taskmanager/contents/config/main.xml && \
  echo "**** cleanup ****" && \
  apt-get autoclean && \
  rm -rf \
    /config/.cache \
    /var/lib/apt/lists/* \
    /var/tmp/* \
    /tmp/*

# add local files
COPY /root /

RUN apt-get update && apt-get install -y \
 vim git tmux terminator task-japanese-desktop xdotool \
 && curl -fsSL https://code-server.dev/install.sh | bash \
 && rm -fr /var/lib/apt/lists/*
RUN mkdir -p /config/.config/code-server \
 && echo -e "bind-addr: 0.0.0.0:8000\nauth: none\npassword: false\ncert: false\n" > /config/.config/code-server/config.yaml \
 && echo -e "code-server serve-local --host 0.0.0.0 --port 8000\n" > /config/.config/code-server/start \
 && chmod +x /config/.config/code-server/start \
 && ln -s .config/code-server/start /config/code-server \
 && chown -R abc:staff /config/.config/code-server

# ports and volumes
EXPOSE 3000
VOLUME /config
