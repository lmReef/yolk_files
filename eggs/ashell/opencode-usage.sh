#!/usr/bin/env bash
# Ashell custom-module poller: OpenCode Go plan usage (5h | 7w | 1m).
#
# listen_cmd must be a continuously running process (ashell reads each JSON
# line it outputs), so this polls on a loop and emits only on change.
#
# Queries the (undocumented) console usage endpoint with the API key that
# `opencode auth login opencode` stores in ~/.local/share/opencode/auth.json:
#
#   GET https://opencode.ai/zen/go/v1/usage
#   Authorization: Bearer <key>
#
# Response shape:
#   {"usage": {"rolling": {"percent", "status", "resetsAt"},
#              "weekly": {...}, "monthly": {...}}}
#
# "rolling" is the 5-hour window; percentages are amount used.
# A custom User-Agent is required — Cloudflare rejects empty/default ones.

interval=60
url="https://opencode.ai/zen/go/v1/usage"
key_file="$HOME/.local/share/opencode/auth.json"

last="init"
while true; do
  text=""
  alt=""
  if key=$(jq -r '.["opencode-go"].key // empty' "$key_file" 2>/dev/null) && [[ -n "$key" ]]; then
    if body=$(curl -s -m 10 -A "ashell-usage/1" -H "Authorization: Bearer $key" "$url"); then
      text=$(jq -r '"\(.usage.rolling.percent)% | \(.usage.weekly.percent)% | \(.usage.monthly.percent)%"' <<<"$body" 2>/dev/null)
      # alt "warn" lets ashell show a red alert dot (Button + alert = ".*warn")
      if [[ $(jq -r '[.usage.rolling.percent, .usage.weekly.percent, .usage.monthly.percent] | max' <<<"$body") -ge 75 ]]; then
        alt="opencode warn"
      else
        alt="opencode"
      fi
    else
      text=""; alt=""
    fi
  fi
  if [[ "$text" != "$last" ]]; then
    printf '{"text": "%s", "alt": "%s"}\n' "$text" "$alt"
    last="$text"
  fi
  sleep "$interval"
done
