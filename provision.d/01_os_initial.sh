killall -9 apt-get >/dev/null 2>&1

apt-get update -yqq

# even if update fails, continue with clean exit code
/bin/true
