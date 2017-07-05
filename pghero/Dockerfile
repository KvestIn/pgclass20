FROM debian:jessie

RUN apt-get update && apt-get install -y apt-transport-https

RUN wget -qO - https://deb.packager.io/key | apt-key add -

RUN echo "deb https://deb.packager.io/gh/pghero/pghero jessie master" | sudo tee /etc/apt/sources.list.d/pghero.list

RUN apt-get update && apt-get install -y pghero

RUN mkdir -p /pghero

WORKDIR /pghero

ADD pghero.yml 

EXPOSE 3001

ENTRYPOINT service restart pghero && tail -f /var/log/pghero
