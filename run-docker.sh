debian-kde() {
  docker run -d \
  --name=webtop-kde \
  -e PUID=1000 \
  -e PGID=1000 \
  -e TZ=Asia/Tokyo \
  -p 3032:3000 \
  --shm-size="2gb" \
  -v /home/webtop/bian-kde:/config \
  lscr.io/linuxserver/webtop:debian-kde
}

docker rm -f webtop-kde
debian-kde
