# Infrastructure Repo Instructions

## Compact Summaries

When compacting, preserve changed files, commands run, test or plan output, unresolved risks, and the next intended command. Drop exploration logs once the relevant paths and decisions are known.

## Merge Requests

Always squash commits and delete the source branch when merging:

```sh
glab mr merge <id> --squash --remove-source-branch
```

Never use `--squash=false`. Never omit `--remove-source-branch`.
