LIB="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

if [ -z "$BIGGULP_SEPARATE_TASKS" ]; then
  BIGGULP_SEPARATE_TASKS="yes"
fi

if [ -z "$BIGGULP_USE_DOUBLE_QUOTES" ]; then
  BIGGULP_USE_DOUBLE_QUOTES="yes"
fi

if [ -z "$BIGGULP_USE_CONFIG" ]; then
  BIGGULP_USE_CONFIG="yes"
fi

if [ -z "$BIGGULP_CREATE_WATCH_FILE" ]; then
  BIGGULP_CREATE_WATCH_FILE="yes"
fi

if [ -z "$BIGGULP_ROOT" ]; then
  BIGGULP_ROOT="$LIB"
fi

if [ -z "$BIGGULP_TASK_DIR" ]; then
  BIGGULP_TASK_DIR="tasks"
fi

function __biggulp_install_gulp {
  npm install --save-dev gulp
  if [ "$BIGGULP_SEPARATE_TASKS" == "yes" ]; then
    npm install --save-dev require-dir
  fi
}

function __biggulp_init {
  __biggulp_install_gulp

  if [ "$BIGGULP_SEPARATE_TASKS" == "yes" ]; then
    __biggulp_create_task_dir
  fi
  __biggulp_create_gulpfile

  if [ "$BIGGULP_USE_CONFIG" == "yes" ] && [ "$BIGGULP_SEPARATE_TASKS" == "yes" ]; then
    __biggulp_create_config
  fi

  if [ "$BIGGULP_CREATE_WATCH_FILE" == "yes" ]; then
    __biggulp_create_watchfile
  fi
}

function __biggulp_create_task_dir {
  if [ ! -d "$BIGGULP_TASK_DIR" ]; then
    mkdir -p "$BIGGULP_TASK_DIR"
    __file_created "$BIGGULP_TASK_DIR/"
  fi
}

function __biggulp_create_gulpfile {
  local template="gulpfile.js.template"
  if [ "$BIGGULP_SEPARATE_TASKS" == "yes" ]; then
    template="gulpfile.dir.js.template"
  fi

  if [ "$BIGGULP_USE_DOUBLE_QUOTES" == "yes" ]; then
    sed "s/'/\"/g" "$LIB/$template" > gulpfile.js
  else
    cat "$BIGGULP_ROOT/$template" > gulpfile.js
  fi

  __file_created "gulpfile.js"
}

function __biggulp_create_config {
  touch "$BIGGULP_TASK_DIR/config.js"
  echo "module.exports = {};" > "$BIGGULP_TASK_DIR/config.js"
  __file_created "tasks/config.js"
}

function __biggulp_create_watchfile {
  if [ "$BIGGULP_USE_DOUBLE_QUOTES" == "yes" ]; then
    sed "s/'/\"/g" "$BIGGULP_ROOT/watch.js.template" > "$BIGGULP_TASK_DIR/watch.js"
    __file_created "tasks/watch.js"
  else
    cat "$BIGGULP_ROOT/watch.js.template" >> "$BIGGULP_TASK_DIR/watch.js"
  fi
}

function __file_created {
  echo "$(green 'created -> ') $1"
}

function bigg {
  __biggulp_init
}
