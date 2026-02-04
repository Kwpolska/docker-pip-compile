#!/bin/bash
set -euo pipefail
projectdir="${1:-}"
dockerimage="dockerpiptools:latest"

if [[ -z "$projectdir" ]]; then
  projectdir="$(pwd)"
fi

if [[ "$projectdir" == *"requirements.in" ]]; then
  projectdir="$(dirname "$projectdir")"
fi

if [[ ! -f "$projectdir/requirements.in" ]]; then
  echo "Error: $projectdir/requirements.in does not exist" >&2
  exit 1
fi

docker image inspect "$dockerimage" > /dev/null 2>&1 || docker build -t "$dockerimage" "$(dirname "$0")"

tmpdir=$(mktemp -d)
trap 'rm -rf $tmpdir' EXIT

cp "$projectdir/requirements.in" "$tmpdir/requirements.in"
docker run --rm -v "$tmpdir":/app "$dockerimage"
cp "$tmpdir/requirements.txt" "$projectdir/requirements.txt"
