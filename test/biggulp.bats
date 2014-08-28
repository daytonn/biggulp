#!/usr/bin/env bats

load test_helper

@test "it has a separate tasks variable" {
  [ "$BIGGULP_SEPARATE_TASKS" == "yes" ]
}

@test "it defers if the separate tasks variable is set" {
  BIGGULP_SEPARATE_TASKS="no"
  source "$ROOT/biggulp.sh"
  [ "$BIGGULP_SEPARATE_TASKS" == "no" ]
}

@test "it has a use double quotes variable" {
  [ "$BIGGULP_USE_DOUBLE_QUOTES" == "yes" ]
}

@test "it defers if the use double quotes variable is set" {
  BIGGULP_USE_DOUBLE_QUOTES="no"
  source "$ROOT/biggulp.sh"
  [ "$BIGGULP_USE_DOUBLE_QUOTES" == "no" ]
}

@test "it has a use config variable" {
  [ "$BIGGULP_USE_CONFIG" == "yes" ]
}

@test "it defers if the use config variable is set" {
  BIGGULP_USE_CONFIG="no"
  source "$ROOT/biggulp.sh"
  [ "$BIGGULP_USE_CONFIG" == "no" ]
}

@test "it has a create watch file variable" {
  [ "$BIGGULP_CREATE_WATCH_FILE" == "yes" ]
}

@test "it defers if the create watch file variable is set" {
  BIGGULP_CREATE_WATCH_FILE="no"
  source "$ROOT/biggulp.sh"
  [ "$BIGGULP_CREATE_WATCH_FILE" == "no" ]
}

@test "it has a root file variable" {
  [ "$BIGGULP_ROOT" == "$LIB" ]
}

@test "it defers if the root file variable is set" {
  BIGGULP_ROOT="some/path"
  source "$ROOT/biggulp.sh"
  [ "$BIGGULP_ROOT" == "some/path" ]
}

@test "it has a task dir variable" {
  [ "$BIGGULP_TASK_DIR" == "tasks" ]
}

@test "it defers if the task dir variable is set" {
  BIGGULP_TASK_DIR="some/path"
  source "$ROOT/biggulp.sh"
  [ "$BIGGULP_TASK_DIR" == "some/path" ]
}

@test "__file_created writes a color formatted string" {
  [ "$(__file_created 'foo')" == "$(green 'created -> ') foo" ]
}

@test "__biggulp_create_watchfile writes a watchfile in the tasks directory" {
  BIGGULP_TASK_DIR="$BATS_TMPDIR"
  source "$ROOT/biggulp.sh"
  __biggulp_create_watchfile

  [ -f "$BATS_TMPDIR/watch.js" ]
}

@test "__biggulp_create_watchfile uses prefered quotations" {
  BIGGULP_TASK_DIR="$BATS_TMPDIR"
  source "$ROOT/biggulp.sh"
  __biggulp_create_watchfile

  [ -n "$(cat "$BIGGULP_TASK_DIR/watch.js" | grep \")" ]

  BIGGULP_USE_DOUBLE_QUOTES="no"
  source "$ROOT/biggulp.sh"
  __biggulp_create_watchfile

  [ -n "$(cat "$BIGGULP_TASK_DIR/watch.js" | grep \')" ]
}

@test "__biggulp_create_config creates a config file in the tasks folder" {
  BIGGULP_TASK_DIR="$BATS_TMPDIR"
  source "$ROOT/biggulp.sh"
  __biggulp_create_config

  [ -f "$BIGGULP_TASK_DIR/config.js" ]
}
