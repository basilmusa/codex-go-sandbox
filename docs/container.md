# Container and tools

## Repository layout

| File | Purpose |
| --- | --- |
| `Dockerfile` | Builds the Ubuntu development image and installs tools. |
| `codex-go-box` | Launches `codex-dev-agent` with project and configuration mounts. |
| `mcp-config/*.toml` | Example additions to the host Codex configuration. |
| `.dockerignore` | Excludes all build-context files; the image installs tools without copying project source. |
| `.gitbook.yaml` | Points GitBook at `docs/` and its navigation files. |
| `docs/` | User documentation. |

## Bundled tools

These defaults come from the Dockerfile. Arguments set to `latest` resolve during image builds; the resulting image's installed version depends on build time.

| Component | Dockerfile default |
| --- | --- |
| Ubuntu | `24.04` |
| Go | `1.26.4` |
| Node.js | `24.x` |
| Codex CLI | `latest` |
| Playwright MCP | `0.0.77` |
| Context7 MCP | `latest` |
| Chrome DevTools MCP | `latest` |
| OpenSpec | `1.6.0` |
| golangci-lint | `2.5.0` |
| Buf | `1.71.0` |
| Google Chrome | Stable package from Google's apt repository |

The image also includes Git, curl, jq, make, GCC/G++, build-essential, ripgrep, Python 3 with pip and venv support, Vim, less, and GnuPG. Both `EDITOR` and `VISUAL` are set to `vim`.

## Runtime behavior

The launcher supplies:

* `--user` with your host UID and GID to preserve project file ownership.
* A supplementary group matching the Docker socket's group.
* `--init` for process reaping and signal handling.
* `--shm-size=1g` for shared memory, including browser workloads.
* Bind mounts for the current directory, Codex configuration, and Docker socket.

Inside the image, `HOME` is `/codex-config-dir`. Cache locations are `/tmp/cache` for `XDG_CACHE_HOME` and `/tmp/npm-cache` for npm. Playwright temporary directories are also created under `/tmp`. The Dockerfile makes these runtime directories writable for the host UID used by the launcher.

## Access boundaries

The default command starts Codex with `--sandbox danger-full-access` inside the container. The project mount is writable, as is the shared Codex configuration directory.

The mounted `/var/run/docker.sock` grants access to the host Docker daemon. Processes that can use it can request additional host mounts and containers, so the launcher does not provide a strict security boundary around the current folder. It also does not disable network access.

Use this setup with trusted projects and commands. If you need a tighter environment, change the launcher to remove Docker socket access and review the remaining mounts and command settings.
