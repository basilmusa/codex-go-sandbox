# Daily usage

Run the launcher from your application's directory:

```sh
codex-go-box
```

The current directory is mounted at the same absolute path inside the container and becomes its working directory. Edits made there are edits to your host files.

## Run a shell or command

Arguments replace the Dockerfile's default command. Start Bash with:

```sh
codex-go-box bash
```

Inside a Go project, you can also run commands directly:

```sh
codex-go-box go test ./...
codex-go-box golangci-lint run
codex-go-box bash -lc 'go version && node --version'
```

The launcher always allocates an interactive terminal with `-it`; it is intended for terminal sessions. Adapting it for CI or redirected input may require changing those flags.

## Persistence

| Location | Behavior |
| --- | --- |
| Current project directory | Bind-mounted; file changes persist on the host. |
| Host `~/.codex` | Mounted at `/codex-config-dir/.codex`; state and configuration persist. |
| Other container files, including `/tmp` caches | Removed when the container exits. |

The launcher uses `--rm`. Exit the shell with `exit` or Ctrl+D; after the main process stops, Docker removes the container. Globally installed tools are supplied by the image, so [rebuild it](maintenance.md) to update them.

## Host services and Testcontainers

The launcher adds `host.docker.internal` using Docker's `host-gateway` mapping. Applications inside the container can use that hostname to reach a host service, provided the service listens on a reachable interface and the host firewall permits access. A service bound only to host loopback may need additional configuration.

For example, a database connection from the container can target `host.docker.internal:5432` when PostgreSQL is exposed on that port.

The mounted Docker socket lets Testcontainers-based tests request containers from the host daemon. Those containers run alongside this development container. Their images, volumes, and lifecycle are managed by the host Docker daemon; removing the development container does not itself clean them up.

There are no port publishing flags in the launcher. To expose a server started inside the development container to the host, add an appropriate `-p` mapping to a local copy of the launcher or an equivalent `docker run` command.
