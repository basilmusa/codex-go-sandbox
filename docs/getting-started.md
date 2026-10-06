# Installation

## Requirements

The launcher expects a Linux host with Docker, a running Docker daemon, and permission to access `/var/run/docker.sock`. It uses GNU `stat` to determine the socket's group. The Dockerfile downloads Linux amd64 binaries for Go and Buf and installs the amd64 Google Chrome package, so use an x86-64 build environment. Other platforms may require changes to the image and launcher.

You also need Git to obtain the repository, network access for the image build, and `~/.local/bin` on your shell's `PATH` if you use the symlink below.

## Build the image

From this repository's root, run:

```sh
docker build --no-cache -t codex-dev-agent .
```

The tag must match `codex-dev-agent`, which is the image name in the launcher. The build installs the tools described in [Container and tools](container.md).

## Install the launcher

From the repository root:

```sh
mkdir -p "$HOME/.local/bin" "$HOME/.codex"
ln -s "$PWD/codex-go-box" "$HOME/.local/bin/codex-go-box"
```

If `~/.local/bin` is missing from `PATH`, add this to your shell startup file and reload your shell:

```sh
export PATH="$HOME/.local/bin:$PATH"
```

The symlink points to this checkout. Moving the checkout requires updating the link. If a launcher already exists at that destination, inspect it before replacing it.

## Start a session

Change to the project you want to work on, then run:

```sh
cd /path/to/your/project
codex-go-box
```

With no arguments, Docker uses the image's default command: `codex --sandbox danger-full-access`. The launcher mounts your host `~/.codex` directory for Codex state and configuration. Authentication must be available there or completed through the CLI when prompted.

To check the tools from a shell instead:

```sh
codex-go-box bash
go version
node --version
buf --version
golangci-lint --version
exit
```
