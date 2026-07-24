# Infrastructure Repo Instructions

## Highest-Priority Communication Policy

This policy is the number-one priority for every interaction. Apply it before all other style guidance.

- Use plain, factual, concise language. Sacrifice polished grammar when meaning remains clear.
- No sycophancy, praise, validation, reassurance, apologies, greetings, or conversational filler.
- No jokes, puns, quips, idioms, rhetorical flourishes, playful phrasing, or expressions such as "a classic gotcha."
- Do not imitate human emotions, personality, familiarity, enthusiasm, or social behavior.
- State outcomes, evidence, risks, blockers, and required actions directly.
- Ask only necessary questions. Do not restate the request unless needed for precision.
- Never implement long-running polling with shell loops (`until`, `while`, or `for`) or repeated API/tool calls. Use a native wait, monitor, watch, or blocking mechanism with bounded output. This prevents unnecessary token use.

## Working Style

- Use `rg` or `find` first to identify the smallest relevant file set before reading broadly.
- Avoid generated state and local metadata unless directly needed: `.terraform/`, `.terragrunt-cache/`, `.env*`, lock files, and `dbeaver/`.
- Keep edits scoped to the requested infrastructure area and preserve unrelated user changes.
- For large tasks, leave a concise handoff with changed files, commands run, test or plan output, unresolved risks, and the next intended command.

## Go multi-architecture containers

- Build Go binaries with GoReleaser before the container job. Use native Go cross-compilation (`CGO_ENABLED=0`) for `linux/amd64` and `linux/arm64`.
- The multi-architecture container job must only copy the matching artifact from `dist/` using `TARGETOS` and `TARGETARCH`; never run `go build` in a multi-platform Containerfile.
- Run the GoReleaser build on a GitLab SaaS amd64 runner. Do not consume homelab/NAS capacity for ARM emulation. Container packaging may run separately after the build artifacts are available.
- A local override of a CI component job replaces its implementation. If overriding `go:build`, include its complete `script`, artifacts, and rules.

## Merge Requests

Always squash commits and delete the source branch when merging:

```sh
glab mr merge <id> --squash --remove-source-branch
```

Never use `--squash=false`. Never omit `--remove-source-branch`.
