FROM ubuntu:latest

ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update && apt-get install -y \
    android-tools-adb android-tools-fastboot \
    wget \
    && rm -rf /var/lib/apt/lists/*

