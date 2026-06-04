FROM mcr.microsoft.com/devcontainers/python:1-3.13

SHELL ["/bin/bash", "-o", "pipefail", "-c"]

RUN rm -f /etc/apt/sources.list.d/yarn.list \
    && apt-get update \
    && DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
        bluez \
        libffi-dev \
        libssl-dev \
        libjpeg-dev \
        zlib1g-dev \
        autoconf \
        build-essential \
        libopenjp2-7 \
        libtiff6 \
        libturbojpeg0-dev \
        tzdata \
        ffmpeg \
        liblapack3 \
        liblapack-dev \
        libatlas-base-dev \
        git \
        libpcap-dev \
        unzip \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* \
    && source /usr/local/share/nvm/nvm.sh \
    && nvm install --lts \
    && pip install --upgrade wheel pip uv

COPY --from=ghcr.io/alexxit/go2rtc:latest /usr/local/bin/go2rtc /bin/go2rtc

EXPOSE 8123

VOLUME /config

USER vscode
ENV VIRTUAL_ENV="/home/vscode/.local/ha-venv"
RUN uv venv $VIRTUAL_ENV
ENV PATH="$VIRTUAL_ENV/bin:$PATH"

COPY requirements.txt /tmp/requirements.txt
RUN uv pip install --prerelease allow -r /tmp/requirements.txt

COPY --chmod=0755 container /usr/local/bin/container
COPY --chmod=0755 hassfest /usr/local/bin/hassfest

USER root
RUN mkdir -p /config \
    && chown -R vscode:vscode /config \
    && echo "vscode ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/vscode \
    && chmod 0440 /etc/sudoers.d/vscode

USER vscode
CMD ["container"]
