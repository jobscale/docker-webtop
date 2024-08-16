debian-kde() {
  docker run \
  --name webtop-kde \
  --privileged \
  -e PUID=1000 \
  -e PGID=1000 \
  -e TZ=Asia/Tokyo \
  -e CUSTOM_PORT=2999 \
  -e CUSTOM_USER=jobscale \
  -e USERNAME=jobscale \
  -e USER=jobscale \
  -p 2999:2999 \
  -p 2997:8000 \
  --memory 3g \
  --shm-size 2g \
  -v /home/webtop/debian-kde:/config \
  -d ghcr.io/jobscale/docker-webtop

  # lscr.io/linuxserver/webtop:debian-kde
}

{
  docker pull ghcr.io/jobscale/docker-webtop
  docker rm -f webtop-kde
  debian-kde
  docker logs --since 5m -f webtop-kde
}
