# MCP server configuration

The `mcp-config` directory contains TOML snippets intended for the host file `~/.codex/config.toml`. The launcher mounts that configuration directory into the container at `/codex-config-dir/.codex`.

The snippets are not loaded automatically. Merge the sections you need into your existing configuration, preserving unrelated settings and avoiding duplicate TOML tables. Restart your session after changing configuration. These examples reproduce the repository snippets; compatibility with a particular CLI version should be checked if a setting is rejected.

## Playwright

From `mcp-config/config.add-mcp-playwright.toml`:

```toml
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
```

This uses the image's Chrome installation in headless mode. Output in `/tmp/playwright-mcp-output` lasts only for the container session; copy anything you want to keep into your project directory before exiting.

## Context7

From `mcp-config/config.add-mcp-context7.toml`:

```toml
[mcp_servers.context7]
command = "context7-mcp"
args = []
startup_timeout_ms = 30000
```

The image installs the `@upstash/context7-mcp` npm package globally.

## Chrome DevTools

From `mcp-config/config.add-mcp-chromedevtools.toml`:

```toml
[mcp_servers.chrome-devtools]
command = "chrome-devtools-mcp"
args = [
  "--headless=true",
  "--isolated=true",
  "--executable-path=/usr/bin/google-chrome",
  "--chrome-arg=--no-sandbox"
]
startup_timeout_sec = 20
tool_timeout_sec = 120

[mcp_servers.chrome-devtools.env]
CHROME_DEVTOOLS_MCP_NO_USAGE_STATISTICS = "1"
CHROME_DEVTOOLS_MCP_NO_UPDATE_CHECKS = "1"
```

## Linear

From `mcp-config/config.add-linear.toml`:

```toml
[features]
rmcp_client = true

[mcp_servers.linear]
url = "https://mcp.linear.app/mcp"
```

Linear uses a remote endpoint rather than a program installed in the image. Account access and any authentication required by the service are separate from building this container. If your configuration already has a `[features]` table, add the setting to that table instead of creating another one.
