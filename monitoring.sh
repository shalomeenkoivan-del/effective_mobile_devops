#!/usr/bin/env bash

proccess_name="test"
task_log_file="/var/log/monitoring.log"
timedate="$(date '+%d_%m_%Y_%H_%M_%S')"
url="https://test.com/monitoring/test/api"
test_state_file="/media/sf_Effective_Mobile_DevOps/test_state"

if pgrep -x "$proccess_name" > /dev/null 2>&1; then
test_state="active"
else
test_state="inactive"
fi

if [[ "$test_state" == "inactive" ]]; then
echo "$test_state" > "$test_state_file"
exit 0
fi

prev_state="inactive"
if [[ -f "$test_state_file" ]]; then
  prev_state="$(cat "$test_state_file" || echo "inactive")"
fi

echo "$test_state" > "$test_state_file"

if [[ "$prev_state" == "inactive" && "$test_state" == "active" ]]; then
echo "$timedate Process '$proccess_name' was restarted" >> "$task_log_file"
fi

if ! curl -fsS "$url" > /dev/null 2>&1; then
echo "$timedate HTTPS-request to $url failed" >> "$task_log_file"
fi

exit 0
