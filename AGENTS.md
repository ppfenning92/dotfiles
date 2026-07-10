# Infrastructure Repo Instructions

## Working Style

- Use `rg` or `find` first to identify the smallest relevant file set before reading broadly.
- Avoid generated state and local metadata unless directly needed: `.terraform/`, `.terragrunt-cache/`, `.env*`, lock files, and `dbeaver/`.
- Keep edits scoped to the requested infrastructure area and preserve unrelated user changes.
- For large tasks, leave a concise handoff with changed files, commands run, test or plan output, unresolved risks, and the next intended command.

## Merge Requests

Always squash commits and delete the source branch when merging:

```sh
glab mr merge <id> --squash --remove-source-branch
```

Never use `--squash=false`. Never omit `--remove-source-branch`.
