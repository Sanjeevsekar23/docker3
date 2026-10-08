#!/usr/bin/env bash
set -euo pipefail

cd "$(dirname "$0")"

docker build --pull -t college-department-portal:verification .
docker run --rm -d --name college-portal-verification -p 8088:80 college-department-portal:verification
cleanup() {
  docker rm -f college-portal-verification >/dev/null 2>&1 || true
}
trap cleanup EXIT

for _ in {1..30}; do
  if curl --fail --silent --show-error http://127.0.0.1:8088/ | grep -q 'Computer Science & Engineering'; then
    printf 'Verification passed: portal served the expected content.\n'
    exit 0
  fi
  sleep 1
done

printf 'Verification failed: portal did not serve the expected content.\n' >&2
exit 1
