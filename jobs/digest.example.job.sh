# Sample job: a morning dev digest. Copy to jobs/<name>.job.sh and tweak.
# Read-only: it summarizes your GitHub activity and notifies you — changes nothing.

JOB_NAME="digest"
SCHEDULE_HOUR=8
SCHEDULE_MINUTE=30

PROMPT="You are my morning dev digest. Using gh and git (read-only), produce a short,
skimmable summary:
1. My open PRs across GitHub (gh search prs --author @me --state open) with their review
   and CI status.
2. Anything stuck: no reviewer, failing checks, or merge conflicts.
3. What I pushed in the last day, if anything.
Be concise — a handful of bullet lines, not prose. Make no changes of any kind.
End your reply with a one-line headline (e.g. '3 open PRs, 1 failing CI')."

WORKING_DIR="$HOME"
ADD_DIRS=()
ALLOWED_TOOLS="Read Grep Glob Bash"   # Bash so it can run gh/git (read-only usage)
NOTIFY=1
GIT_OUTCOME=0
