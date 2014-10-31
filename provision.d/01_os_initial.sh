killall -9 apt-get >/dev/null 2>&1

apt-get update -yqq
# shell shocker fix
apt-get install --only-upgrade bash
apt-get install zip
# even if update fails, continue with clean exit code
/bin/true
