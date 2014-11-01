killall -9 apt-get >/dev/null 2>&1

apt-get update -yqq
# shell shocker fix
apt-get install -y --only-upgrade bash
apt-get install -yqq zip
# even if update fails, continue with clean exit code
/bin/true
