FROM ghcr.io/linuxserver/baseimage-selkies:debiantrixie

# set version label
ARG BUILD_DATE
ARG VERSION
LABEL build_version="Linuxserver.io version:- ${VERSION} Build-date:- ${BUILD_DATE}"
LABEL maintainer="thelamer"

# title
ENV TITLE="Debian XFCE"

RUN \
  echo "**** add icon ****" && \
  curl -o \
    /usr/share/selkies/www/icon.png \
    https://raw.githubusercontent.com/linuxserver/docker-templates/master/linuxserver.io/img/webtop-logo.png && \
  echo "**** install packages ****" && \
  apt-get update && \
  DEBIAN_FRONTEND=noninteractive \
  apt-get install -y --no-install-recommends \
    elementary-xfce-icon-theme \
    greybird-gtk-theme \
    libxfce4ui-utils \
    mousepad \
    thunar \
    xfce4-appfinder \
    xfce4-panel \
    xfce4-session \
    xfce4-settings \
    xfce4-taskmanager \
    xfce4-terminal \
    xfconf \
    xfdesktop4 \
    xfwm4 && \
  echo "**** xfce tweaks ****" && \
  mv \
    /usr/bin/exo-open \
    /usr/bin/exo-open-real && \
  mv \
    /usr/bin/thunar \
    /usr/bin/thunar-real && \
  rm -f \
    /etc/xdg/autostart/xscreensaver.desktop && \
  echo "**** cleanup ****" && \
  apt-get autoclean && \
  rm -rf \
    /config/.cache \
    /var/lib/apt/lists/* \
    /var/tmp/* \
    /tmp/*

# add local files
COPY /root /

# ports and volumes
EXPOSE 3000
VOLUME /config

# Japanese Fonts and Language
ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update && apt-get install -y locales task-japanese-desktop \
 fonts-liberation fonts-noto-cjk fonts-ipafont fonts-takao \
 && locale-gen ja_JP.UTF-8 \
 && update-locale LANG=ja_JP.UTF-8 \
 && apt-get clean && rm -fr /var/lib/apt/lists/*

# Google Chrome - remove Chromium
ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update && apt-get install -y --no-install-recommends \
 ca-certificates curl wget libu2f-udev \
 && curl -sLO "https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb" \
 && ( apt-get install -y --no-install-recommends ./google-chrome-stable_current_amd64.deb || echo "Code: $?" ) \
 && rm google-chrome-stable_current_amd64.deb \
 && apt-get clean && rm -fr /var/lib/apt/lists/*

# IDE
ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update && apt-get install -y --no-install-recommends \
 vim git tmux terminator xdotool x11-apps imagemagick ffmpeg \
 && curl -fsSL https://code-server.dev/install.sh | bash \
 && mkdir -p /config/.config/code-server \
 && echo -e "bind-addr: 0.0.0.0:8000\nauth: none\npassword: false\ncert: false\n" > /config/.config/code-server/config.yaml \
 && echo -e "code-server serve-local --host 0.0.0.0 --port 8000\n" > /config/.config/code-server/start \
 && chmod +x /config/.config/code-server/start \
 && ln -s .config/code-server/start /config/code-server \
 && chown -R abc:staff /config/.config/code-server \
 && apt-get clean && rm -fr /var/lib/apt/lists/*
