#!/usr/bin/env bash
#
# Launch the app using rerun (reloads when files are modified)

export YAMMER_DOMAIN=https://www.yammer.com
bundle exec rerun app.rb

# Otherwise just 'bundle exec ruby app.rb'
