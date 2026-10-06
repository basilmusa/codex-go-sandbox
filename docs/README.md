# Codex Go Sandbox

Codex Go Sandbox provides a Docker development environment for working on Go projects with the Codex CLI. It bundles Go, Node.js, browser automation tools, and development utilities in an Ubuntu image.

This repository contains the image definition, the `codex-go-box` launcher, and example MCP server configuration. Your application source lives in whichever project directory you launch it from; this repository does not contain a Go application or Go test suite.

Start with [installation](getting-started.md), then read [daily usage](usage.md) and [how the container works](container.md). See [MCP configuration](mcp-servers.md) for the supplied integration snippets.

The launcher preserves the project's absolute path inside the container, runs as your host user, and shares your host Codex configuration. Project edits and Codex configuration changes persist after the container exits.

The container also receives access to the host Docker daemon. Read the [access boundaries](container.md#access-boundaries) before using it with unfamiliar projects.

The project uses the Unlicense; see the repository's `LICENSE` for the full terms.
