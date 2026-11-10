# cron-claude

Run headless [Claude Code](https://docs.claude.com/en/docs/claude-code) agents as
scheduled `launchd` jobs. One small scaffold: a **job** is a tiny config file
(schedule + prompt + allowed dirs/tools), and the tool runs it, writes a status line,
sends a desktop notification, and serves a dashboard. Add a new scheduled agent by
dropping a file in `jobs/` — no rebuild.

## Why

Lots of chores are "run an agent on a schedule and tell me what it found": a morning
repo digest, a backlog triage, a dependency-update scan, a doc sync. This is the reusable
machine for all of them. Runs locally (so the agent can see your files); `launchd` is the
scheduler, so there's no daemon to babysit.

## Usage

```bash
cp jobs/example.job.sh jobs/digest.job.sh    # define a job
$EDITOR jobs/digest.job.sh

bin/cron-claude list                 # list jobs
DRY_RUN=1 bin/cron-claude run digest # preview (read-only, no side effects)
bin/cron-claude run digest           # run once now
bin/cron-claude install digest       # schedule it (daily)
bin/cron-claude status               # last-run status for all jobs
bin/cron-claude dashboard            # http://localhost:4321
bin/cron-claude uninstall digest
```

## A job

```sh
JOB_NAME="digest"
SCHEDULE_HOUR=8; SCHEDULE_MINUTE=30
PROMPT="Summarize yesterday's commits in the working dir. Make no edits."
WORKING_DIR="$HOME/code/myproject"
ADD_DIRS=("$HOME/notes")
ALLOWED_TOOLS="Read Grep Glob"       # read-only by default; opt into writes
NOTIFY=1
GIT_OUTCOME=0                        # 1 = report the git HEAD-diff (for committing jobs)
```

For a job that commits to `WORKING_DIR`, set `GIT_OUTCOME=1` and the status line reports
exactly which files landed (derived from git), rather than trusting the agent's summary.

Real job files are gitignored (they name your paths/tasks) — only
`jobs/example.job.sh` is committed.

## Safety

- Jobs are **read-only by default** (`Read Grep Glob`). A job must explicitly opt into
  `Edit`/`Write`/`Bash`. Use whole tool names — fine-grained `Bash(git:*)` patterns
  aren't accepted via `--allowedTools`.
- A job that pushes to a remote or mutates data is an **armed autonomous action**: your
  agent harness may require you to approve installing/running it. That gate is a feature.
- Prefer `DRY_RUN=1` first; keep the agent's reach scoped with `WORKING_DIR` + `ADD_DIRS`.

## Tests

```bash
brew install bats-core
bats test/
```
