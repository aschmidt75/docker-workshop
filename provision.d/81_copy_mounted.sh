# copy over from mounted fs, since when shipped, hosts
# fs go away
cp -rp /mnt /data/

# give permission to all, so that both demo and vagrant user
# can write
chmod -R ag+w /data/mnt

