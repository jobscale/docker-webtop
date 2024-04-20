debian-kde() {
  docker run -d \
  --name=webtop-kde \
  -e PUID=1000 \
  -e PGID=1000 \
  -e TZ=Asia/Tokyo \
  -e CUSTOM_PORT=2999 \
  -e CUSTOM_USER=jobscale \
  -p 2999:2999 \
  --shm-size="2gb" \
  -v /home/webtop/bian-kde:/config \
  ghcr.io/jobscale/docker-webtop

  # lscr.io/linuxserver/webtop:debian-kde
}

docker rm -f webtop-kde
debian-kde
