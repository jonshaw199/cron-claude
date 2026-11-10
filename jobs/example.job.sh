# Example cron-claude job. Copy to jobs/<name>.job.sh and edit.
# A job is just these variables — the scaffold does the rest.

JOB_NAME="example"                 # defaults to the filename
SCHEDULE_HOUR=9                    # 24h local time
SCHEDULE_MINUTE=0

# The task. Use PROMPT for a short inline task, or PROMPT_FILE for a longer one.
PROMPT="Summarize what changed in the git repo at the working dir over the last day.
If nothing changed, say so. Make no edits."
# PROMPT_FILE="$HOME/.config/cron-claude/example.prompt.md"

# Where the agent runs, and which extra dirs it may read.
WORKING_DIR="$HOME"
ADD_DIRS=(
  # "$HOME/some/project"
)

# Tools the agent may use. Default is read-only (Read Grep Glob). Opt into writes
# explicitly, e.g. ALLOWED_TOOLS="Read Edit Write Grep Glob 'Bash(git:*)'".
ALLOWED_TOOLS="Read Grep Glob"

NOTIFY=1                            # desktop notification after each run

# For jobs that commit in WORKING_DIR: derive the outcome from the git HEAD diff
# (what actually landed) instead of the agent's self-reported last line.
GIT_OUTCOME=0
