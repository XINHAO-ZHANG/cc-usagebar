#!/bin/bash
# Combined usage source for the cc-usagebar widget.
# Emits two JSON blobs separated by a sentinel line, so the widget
# can parse both without depending on jq.

export PATH=/usr/local/bin:/opt/homebrew/bin:/usr/bin:/bin

codexbar usage --format json 2>/dev/null || echo '[]'
echo '---CCUSAGE---'
ccusage blocks --active --json 2>/dev/null || echo '{"blocks":[]}'
