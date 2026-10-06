# Publishing with GitBook

The repository is prepared for GitBook Git Sync with a single documentation space mapped to the repository root. The root `.gitbook.yaml` selects `docs/` as the content root:

```yaml
root: ./docs/

structure:
  readme: README.md
  summary: SUMMARY.md
```

The first page is `docs/README.md`. Navigation is defined by `docs/SUMMARY.md`, and the paths under `structure` are relative to the configured content root.

## Connect the repository

In GitBook, configure Git Sync for this repository and the branch you want to use. Map the space to the repository root so GitBook reads the root `.gitbook.yaml`; that file then directs it to `docs/`. Import the repository content into GitBook for the initial sync.

GitBook may create a `gitbook-docs.yaml` file when saving a site's space mappings. Keep the mapping consistent with the root configuration above. For site and space configuration details, see [GitBook's content configuration documentation](https://gitbook.com/docs/docs-as-code/git-sync/content-configuration).

Connecting and publishing in GitBook requires access to the GitBook account and repository integration; adding these files alone does not publish a site.

## Maintain the documentation

Add new Markdown pages under `docs/` and link them once in `SUMMARY.md` in the desired order. Use relative links between documentation pages so the content works both in the repository and in GitBook.

Keep tool versions, commands, mounts, and MCP examples aligned with the Dockerfile, launcher, and TOML snippets. Commit documentation changes to the branch connected to Git Sync. Manage README changes in the repository to avoid conflicts with GitBook edits, as described in the linked GitBook documentation.
