#!/bin/sh
#
# Update stock Debian config stored in repo, using system-wide one

git checkout stock-debian
cp /etc/xdg/awesome/rc.lua rc.lua
git add rc.lua
awesome_version=$(dpkg-query --showformat='${Version}' --show awesome)
echo "Update stock config with version $awesome_version" \
    | git commit --verbose --file=-
git checkout master
