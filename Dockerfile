FROM curlimages/curl:latest as downloader

RUN curl -L -O  https://downloads.mend.io/cli/linux_amd64/mend
RUN curl -L -O  https://unified-agent.s3.amazonaws.com/wss-unified-agent.jar
RUN chmod +x /home/curl_user/mend

FROM openjdk:22-slim-bullseye

WORKDIR /app

COPY --from=downloader /home/curl_user/mend .
COPY --from=downloader /home/curl_user/wss-unified-agent.jar .

CMD ["java", "-jar", "/app/wss-unified-agent.jar"]