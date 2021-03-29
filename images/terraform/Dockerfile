FROM hashicorp/terraform:light
RUN apk add inotify-tools bash docker-cli
SHELL ["/bin/bash", "-c"]
WORKDIR /app
ENTRYPOINT ["tail", "-f"]
CMD ["/dev/null"]
