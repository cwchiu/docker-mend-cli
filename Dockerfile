FROM curlimages/curl:latest as downloader

RUN curl -L -O  https://downloads.mend.io/cli/linux_amd64/mend
RUN curl -L -O  https://unified-agent.s3.amazonaws.com/wss-unified-agent.jar
RUN curl -L -o docker-ce-cli.deb  https://download.docker.com/linux/debian/dists/bullseye/pool/stable/amd64/docker-ce-cli_24.0.4-1~debian.11~bullseye_amd64.deb
RUN chmod +x /home/curl_user/mend

FROM openjdk:22-slim-bullseye

WORKDIR /app

COPY --from=downloader /home/curl_user/mend .
COPY --from=downloader /home/curl_user/wss-unified-agent.jar .
COPY --from=downloader /home/curl_user/docker-ce-cli.deb .

RUN dpkg -i docker-ce-cli.deb && ./mend update
COPY settings.json /root/.mend/config/

CMD ["java", "-jar", "/app/wss-unified-agent.jar"]