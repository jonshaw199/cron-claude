#!/usr/bin/env bats
# Tests for the cron-claude CLI surface (the parts that don't invoke the agent).
# Run: bats test/

setup() {
  BIN="${BATS_TEST_DIRNAME}/../bin/cron-claude"
  export CRON_CLAUDE_JOBS="$BATS_TEST_TMPDIR/jobs"
  export CRON_CLAUDE_STATE="$BATS_TEST_TMPDIR/state"
  mkdir -p "$CRON_CLAUDE_JOBS"
}

@test "no args prints usage" {
  run "$BIN"
  [ "$status" -eq 0 ]
  [[ "$output" == *"scheduled headless Claude jobs"* ]]
}

@test "list shows a defined job" {
  echo 'JOB_NAME="foo"' > "$CRON_CLAUDE_JOBS/foo.job.sh"
  run "$BIN" list
  [ "$status" -eq 0 ]
  [[ "$output" == *"foo"* ]]
}

@test "list with no jobs says so" {
  run "$BIN" list
  [[ "$output" == *"no jobs"* ]]
}

@test "status with no runs is friendly" {
  run "$BIN" status
  [ "$status" -eq 0 ]
  [[ "$output" == *"no runs yet"* ]]
}

@test "unknown job errors out" {
  run "$BIN" run does-not-exist
  [ "$status" -ne 0 ]
  [[ "$output" == *"no such job"* ]]
}

@test "unknown command prints usage and fails" {
  run "$BIN" frobnicate
  [ "$status" -ne 0 ]
}
