FROM ghcr.io/loveretro/tg5040-toolchain:modernize AS base

USER root

RUN apt-get update && apt-get install -y \
    build-essential \
    git \
    wget \
    pkg-config \
    libasound2-dev \
    libxkbcommon-dev \
    libxkbcommon0 \
    cmake \
    autoconf \
    automake \
    libtool \
    python3 \
    python3-dev \
    libfreetype6-dev \
    libexpat1-dev \
    zlib1g-dev \
    libpng-dev \
    libjpeg-dev \
    && rm -rf /var/lib/apt/lists/*

RUN useradd -m builder

FROM base AS builder

USER builder
WORKDIR /home/builder

RUN git clone --depth 1 https://github.com/libretro/beetle-supergrafx-libretro mednafen_supergrafx && \
    cd mednafen_supergrafx && \
    make -j$(nproc) && \
    mkdir -p /home/builder/out && \
    cp mednafen_supergrafx_libretro.so /home/builder/out/

RUN mkdir -p /home/builder/out/info && \
    wget -q -O /home/builder/out/info/beetle_supergrafx.info \
    "https://raw.githubusercontent.com/libretro/libretro-super/master/dist/info/mednafen_supergrafx_libretro.info" || \
    echo "Warning: Could not download info file"

WORKDIR /home/builder

ENTRYPOINT ["bash"]