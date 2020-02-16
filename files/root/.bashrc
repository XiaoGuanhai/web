cat <<'MSG'
     _     _ _            _
    | |   | | |          | |
  __| | __| | |_ ___  ___| |__  ___   ___ _ __
 / _` |/ _` | __/ _ \/ __| '_ \/ __| / __| '_ \
| (_| | (_| | ||  __/ (__| | | \__ \| (__| | | |
 \__,_|\__,_|\__\___|\___|_| |_|___(_)___|_| |_|

MSG

echo "PHP version: ${PHP_VERSION}"

if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
#  elif [ -f /etc/bash_completion.d/yii ]; then
#    . /etc/bash_completion.d/yii
  fi
fi
