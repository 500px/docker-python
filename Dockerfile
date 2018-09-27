FROM python:3.6-stretch

ENV DATADOG_API_KEY=fakekey
ENV DATADOG_HOST=docker

ARG NODE_VERSION=node_10.x
ARG DATADOG_APT_KEY=382E94DE
ARG NODE_APT_KEY=68576280
ARG YARN_APT_KEY=86E50310

COPY ["templates/*.tmpl", "/opt/templates/"]
COPY ["scripts/entrypoint.sh", "/usr/local/bin/entrypoint.sh"]

RUN apt-get update \
 && apt-get install -y \
                    --no-install-recommends \
                    ca-certificates \
                    apt-transport-https \
                    gettext-base \
                    lsb-core \
 && export DISTRO="$(lsb_release -s -c)" \
 && envsubst < /opt/templates/500px.list.tmpl > /etc/apt/sources.list.d/500px.list \
 && apt-key adv --recv-keys --keyserver hkp://keyserver.ubuntu.com:80 \
      $DATADOG_APT_KEY \
      $NODE_APT_KEY \
      $YARN_APT_KEY \
 && apt-get update \
 && apt-get install -y \
                    --no-install-recommends \
                    datadog-agent \
                    nodejs \
                    yarn \
 && yarn global add kms-env@0.3.0 \
 && mv /etc/dd-agent/datadog.conf.example /etc/dd-agent/datadog.conf \
 && rm -rf /var/lib/apt/lists/*

ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
