FROM ubuntu:24.04

ENV DEBIAN_FRONTEND=noninteractive
ENV PATH="/root/.local/bin:/usr/local/go/bin:${PATH}"

# Pin versions
ARG GO_VERSION=1.26.4
ARG CODEX_VERSION=latest
ARG PLAYWRIGHT_MCP_VERSION=0.0.77
ARG CONTEXT7_MCP_VERSION=latest
ARG OPENSPEC_VERSION=1.6.0
ARG CHROME_DEVTOOLS_MCP_VERSION=latest

RUN apt-get update && apt-get install -y --no-install-recommends \
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
    gnupg \
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

# Runtime dirs used by Codex, npm, and Playwright MCP.
ENV HOME=/codex-config-dir
ENV XDG_CACHE_HOME=/tmp/cache
ENV npm_config_cache=/tmp/npm-cache

RUN mkdir -p \
      /codex-config-dir \
      /tmp/cache \
      /tmp/npm-cache \
      /tmp/playwright-mcp-output \
      /tmp/playwright-mcp-user-data \
    && chmod 1777 \
      /codex-config-dir \
      /tmp/cache \
      /tmp/npm-cache \
      /tmp/playwright-mcp-output \
      /tmp/playwright-mcp-user-data

# Install Node 24
RUN curl -fsSL https://deb.nodesource.com/setup_24.x | bash - \
    && apt-get install -y nodejs \
    && rm -rf /var/lib/apt/lists/*

RUN npm install -g \
    @openai/codex@${CODEX_VERSION} \
    @playwright/mcp@${PLAYWRIGHT_MCP_VERSION} \
    chrome-devtools-mcp@${CHROME_DEVTOOLS_MCP_VERSION} \
    @upstash/context7-mcp@${CONTEXT7_MCP_VERSION} \
    @fission-ai/openspec@${OPENSPEC_VERSION}

# Install Google Chrome system-wide.
RUN mkdir -p /etc/apt/keyrings \
    && curl -fsSL https://dl.google.com/linux/linux_signing_key.pub \
      | gpg --dearmor -o /etc/apt/keyrings/google-linux.gpg \
    && echo "deb [arch=amd64 signed-by=/etc/apt/keyrings/google-linux.gpg] http://dl.google.com/linux/chrome/deb/ stable main" \
      > /etc/apt/sources.list.d/google-chrome.list \
    && apt-get update \
    && apt-get install -y google-chrome-stable \
    && rm -rf /var/lib/apt/lists/*

# Install Go from official tarball
RUN curl -fsSL "https://go.dev/dl/go${GO_VERSION}.linux-amd64.tar.gz" -o /tmp/go.tar.gz \
    && rm -rf /usr/local/go \
    && tar -C /usr/local -xzf /tmp/go.tar.gz \
    && rm /tmp/go.tar.gz

WORKDIR /workspace

CMD ["codex", "--sandbox", "danger-full-access"]

