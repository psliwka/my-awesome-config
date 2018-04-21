#!/bin/sh
#
# Show what's changed in system-provided config, with respect to the one stored
# in repo

git show stock-debian:rc.lua | git diff --no-index -- - /etc/xdg/awesome/rc.lua
