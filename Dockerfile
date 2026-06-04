FROM python:3.14-bookworm

SHELL ["/bin/bash", "-o", "pipefail", "-c"]

RUN apt-get update \
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
        curl \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Install Node.js LTS via nodeenv
RUN pip install --upgrade wheel pip uv nodeenv \
    && nodeenv /opt/nodejs --node=lts \
    && rm -rf /root/.cache

ENV PATH="/opt/nodejs/bin:$PATH"

COPY --from=ghcr.io/alexxit/go2rtc:latest /usr/local/bin/go2rtc /bin/go2rtc

EXPOSE 8123

VOLUME /config

RUN useradd -m -s /bin/bash vscode

USER vscode
ENV VIRTUAL_ENV="/home/vscode/.local/ha-venv"
RUN uv venv $VIRTUAL_ENV
ENV PATH="$VIRTUAL_ENV/bin:$PATH"

COPY requirements.txt /tmp/requirements.txt
RUN uv pip install --prerelease allow -r /tmp/requirements.txt

COPY --chmod=0755 container /usr/local/bin/container
COPY --chmod=0755 hassfest /usr/local/bin/hassfest

CMD ["container"]
