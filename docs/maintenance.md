# Maintenance and troubleshooting

## Update installed tools

Rebuild the image from the repository root:

```sh
docker build --no-cache -t codex-dev-agent .
```

Start a new session to use the rebuilt image. Running sessions continue using their existing image. Global npm installations inside a session may fail because the launcher runs as your host UID while the image's global installation paths are root-owned; image rebuilds are the supported update workflow.

Pinned versions can be changed in the Dockerfile or overridden with build arguments. For example, this explicitly uses the Dockerfile's current Go and OpenSpec defaults:

```sh
docker build --no-cache \
  --build-arg GO_VERSION=1.26.4 \
  --build-arg OPENSPEC_VERSION=1.6.0 \
  -t codex-dev-agent .
```

Other arguments include `CODEX_VERSION`, `PLAYWRIGHT_MCP_VERSION`, `CONTEXT7_MCP_VERSION`, `CHROME_DEVTOOLS_MCP_VERSION`, `GOLANGCI_LINT_VERSION`, and `BUF_VERSION`. Replace values with the releases you intend to install. Dependencies obtained through apt or remote installation scripts can still vary between builds.

## Launcher not found

Check that `~/.local/bin` is on `PATH` and that its `codex-go-box` symlink points to the existing checkout. You can also invoke the launcher by its full path while in the desired project directory.

## Docker socket missing or permission denied

Check the host first:

```sh
docker info
ls -l /var/run/docker.sock
```

The launcher requires that exact socket path and reads its group with GNU `stat`. The `--group-add` option addresses socket permissions inside the container; it does not give your host user permission to launch Docker. Rootless Docker or a remote Docker daemon may require adapting the launcher.

## Image missing

Build with the tag `codex-dev-agent`. The launcher uses that fixed tag, so an image built under a different name will not be selected.

## Browser or MCP startup fails

Start a shell and verify the installed commands:

```sh
codex-go-box bash
command -v playwright-mcp context7-mcp chrome-devtools-mcp
/usr/bin/google-chrome --version
```

Check the configuration against the [repository snippets](mcp-servers.md), including the Chrome executable path. The snippets use both millisecond and second timeout keys; if the CLI rejects a key, check the configuration supported by the version installed in your image.

## Cannot connect to a host database

Use `host.docker.internal` from inside the container and confirm that the service listens on an interface reachable from Docker's network. Check the service port and host firewall as well.

## Files disappear after exit

Only the project directory and shared Codex configuration are persisted by the launcher. Save artifacts in the project mount rather than elsewhere in the container. Go, npm, and browser caches in the container are not mounted for persistence.

## Build fails on another architecture

The Dockerfile currently targets amd64 for several downloads and package sources. Supporting another architecture requires selecting compatible Go and Buf binaries and a compatible browser package.
