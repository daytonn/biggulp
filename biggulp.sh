LIB="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

if [ -z "$BIGGULP_TASK_DIR" ]; then
  BIGGULP_TASK_DIR="yes"
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

function __biggulp_install_gulp {
  npm install --save-dev gulp
  if [ "$BIGGULP_TASK_DIR" == "yes" ]; then
    npm install --save-dev require-dir
  fi
}

function __biggulp_init {
  __biggulp_install_gulp

  if [ "$BIGGULP_TASK_DIR" == "yes" ]; then
    __big_gulp_create_task_dir
  fi

  __biggulp_create_gulpfile

  if [ "$BIGGULP_USE_CONFIG" == "yes" ]; then
    __biggulp_create_config
  fi

  if [ "$BIGGULP_CREATE_WATCH_FILE" == "yes" ]; then
    __biggulp_create_watchfile
  fi
}

function __big_gulp_create_task_dir {
  if [ ! -d ./tasks ]; then
    mkdir tasks
    __file_created "tasks/"
  fi
}

function __biggulp_create_gulpfile {
  local template="gulpfile.js.template"
  if [ "$BIGGULP_TASK_DIR" == "yes" ]; then
    template="gulpfile.dir.js.template"
  fi

  if [ "$BIGGULP_USE_DOUBLE_QUOTES" == "yes" ]; then
    sed "s/'/\"/g" "$LIB/$template" > gulpfile.js
  else
    cat "$LIB/$template" > gulpfile.js
  fi

  __file_created "gulpfile.js"
}

function __biggulp_create_config {
  touch tasks/config.js
  echo "module.exports = {};" > tasks/config.js
  __file_created "tasks/config.js"
}

function __biggulp_create_watchfile {
  if [ "$BIGGULP_USE_DOUBLE_QUOTES" == "yes" ]; then
    sed "s/'/\"/g" "$LIB/watch.js.template" > tasks/watch.js
  else
    cat "$LIB/watch.js.template" > tasks/watch.js
  fi
  __file_created "tasks/watch.js"
}

function __file_created {
  echo "$(green 'created -> ') $1"
}
