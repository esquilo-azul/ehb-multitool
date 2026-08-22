TELEGRAM_SOURCE='https://telegram.org/dl/desktop/linux'
TELEGRAM_SOURCE_CACHE="$HOME/.cache/telegram.tar.xz"
TELEGRAM_DIR="$HOME/opt/network/telegram"
TELEGRAM_BIN="$TELEGRAM_DIR/Telegram"

function task_condition() {
  [ -f "$TELEGRAM_BIN" ]
}

function task_fix() {
  wget --continue -O "$TELEGRAM_SOURCE_CACHE" "$TELEGRAM_SOURCE"
  mkdir -p "$TELEGRAM_DIR"
  tar -xf "$TELEGRAM_SOURCE_CACHE" -C "$TELEGRAM_DIR" --strip 1
}
