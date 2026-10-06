This is a codex sandbox with Go lang installed as well as other tools.

Full documentation is available in [docs](docs/README.md), including installation,
container behavior, MCP configuration, and GitBook setup.

# Creating the container for the first time use

First create the docker image:

```
docker build --no-cache -t codex-dev-agent .
```

# Link to your bin directory

Second link the command `codex-go-box` to your bin directory:

```
ln -s `pwd`/codex-go-box ~/.local/bin
```

# Start using the sandbox

Now you can start using it, inside any project folder just run:

```
codex-go-box
```

If you need to start with bash instead of entering codex cli directly:

```
codex-go-box bash
```

This creates a container with the current folder and your Codex configuration
mounted, and starts Codex with `--sandbox danger-full-access`. The launcher also
mounts the host Docker socket for Testcontainers, giving processes access to the
host Docker daemon. See [access boundaries](docs/container.md#access-boundaries).

# To upgrade go version, codex or openspec

To upgrade you need to build the docker image again, running npm inside the
container will not work and will give you permission errors

# Configure the MCP Servers section in ~/.codex/config.toml

File: `~/.codex/config.toml`

```
[mcp_servers.playwright]
command = "playwright-mcp"
args = [
  "--headless",
  "--no-sandbox",
  "--browser", "chrome",
  "--executable-path", "/usr/bin/google-chrome",
  "--isolated",
  "--output-dir", "/tmp/playwright-mcp-output"
]
startup_timeout_ms = 30000

[mcp_servers.context7]
command = "context7-mcp"
args = []
startup_timeout_ms = 30000

```
