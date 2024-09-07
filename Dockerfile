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
  apt-get full-upgrade -y --no-install-recommends && \
  DEBIAN_FRONTEND=noninteractive \
  apt-get install -y --no-install-recommends \
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

SHELL ["bash", "-c"]

RUN apt-get update && apt-get install -y \
 vim git tmux terminator task-japanese-desktop xdotool x11-apps \
 && curl -fsSL https://code-server.dev/install.sh | bash \
 && rm -fr /var/lib/apt/lists/* \
 && mkdir -p /config/.config/code-server \
 && echo -e "bind-addr: 0.0.0.0:8000\nauth: none\npassword: false\ncert: false\n" > /config/.config/code-server/config.yaml \
 && echo -e "code-server serve-local --host 0.0.0.0 --port 8000\n" > /config/.config/code-server/start \
 && chmod +x /config/.config/code-server/start \
 && ln -s .config/code-server/start /config/code-server \
 && chown -R abc:staff /config/.config/code-server

RUN apt-get update && apt-get install -y wget fonts-liberation libu2f-udev \
&& curl -sLO "https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb" \
&& ( apt-get install -y ./google-chrome-stable_current_amd64.deb || echo "Code: $?" ) \
&& rm google-chrome-stable_current_amd64.deb \
&& rm -fr /var/lib/apt/lists/*

# ports and volumes
EXPOSE 3000
VOLUME /config
