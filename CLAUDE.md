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

## Compact Summaries

When compacting, preserve changed files, commands run, test or plan output, unresolved risks, and the next intended command. Drop exploration logs once the relevant paths and decisions are known.

## Go multi-architecture containers

- Use GoReleaser to cross-compile static amd64 and arm64 binaries before the container build.
- Containerfiles copy platform-specific files from `dist/` using `TARGETOS` and `TARGETARCH`; they do not compile Go code.
- Schedule GoReleaser builds on GitLab SaaS runners, not the homelab/NAS. Avoid QEMU/binfmt ARM container builds.
- Overriding an included CI job replaces it. Preserve the required `script`, artifacts, and rules when overriding `go:build`.

## Merge Requests

Always squash commits and delete the source branch when merging:

```sh
glab mr merge <id> --squash --remove-source-branch
```

Never use `--squash=false`. Never omit `--remove-source-branch`.
