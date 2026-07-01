FROM ubuntu:24.04

ENV DEBIAN_FRONTEND=noninteractive
ENV PATH="/root/.local/bin:/usr/local/go/bin:${PATH}"

ARG GO_VERSION=1.26.4

RUN apt-get update && apt-get install -y \
    ca-certificates \
    curl \
    git \
    jq \
    make \
    gcc \
    g++ \
    build-essential \
    ripgrep \
    python3 \
    python3-pip \
    python3-venv \
    vim \
    less \
    && rm -rf /var/lib/apt/lists/*

# Buf for Connect RPC
ARG BUF_VERSION=1.71.0

RUN curl -fsSL \
    "https://github.com/bufbuild/buf/releases/download/v${BUF_VERSION}/buf-Linux-x86_64" \
    -o /usr/local/bin/buf \
    && chmod +x /usr/local/bin/buf

RUN buf --version

# Editor
ENV VISUAL=vim
ENV EDITOR=vim

# Install Node 24
RUN curl -fsSL https://deb.nodesource.com/setup_24.x | bash - \
    && apt-get install -y nodejs \
    && rm -rf /var/lib/apt/lists/*

# Install openspec
RUN npm install -g @fission-ai/openspec@latest

# Install Go from official tarball
RUN curl -fsSL "https://go.dev/dl/go${GO_VERSION}.linux-amd64.tar.gz" -o /tmp/go.tar.gz \
    && rm -rf /usr/local/go \
    && tar -C /usr/local -xzf /tmp/go.tar.gz \
    && rm /tmp/go.tar.gz

# Install Codex CLI using OpenAI's installer
RUN npm install -g @openai/codex

WORKDIR /workspace

CMD ["codex", "--sandbox", "danger-full-access"]

