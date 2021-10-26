
FROM ubuntu:16.04

ENV DEBIAN_FRONTEND=noninteractive
ENV RUNNER_ALLOW_RUNASROOT=true
RUN echo "APT::Get::Assume-Yes \"true\";" > /etc/apt/apt.conf.d/90assumeyes

RUN apt-get update \
    && apt-get install -y --no-install-recommends \
    ca-certificates \
    curl \
    jq \
    git \
    unzip \
    iputils-ping \
    libcurl3 \
    libicu55 \
    libunwind8 \
    netcat \
    yum \
    wget

COPY ./entrypoint.sh .
RUN chmod +x entrypoint.sh
RUN ls -l

CMD ["./entrypoint.sh"]