#!/bin/sh
# Eukhe's files for the build: gildrb/eukhe at EUKHE_REF (default main), a
# shallow checkout in .eukhe/. The pages read its README.md and the files the
# README links to, its .github/media/ images, and the Bend release it pins
# (.github/scripts/pinned_bend.py). Each run fetches the ref again, so a build
# of main shows eukhe's main as it is now.
#
# Usage (in the site's directory, `vp run eukhe`): sh scripts/eukhe.sh
#   EUKHE_REF=<branch, tag or commit> sh scripts/eukhe.sh
set -eu

ref="${EUKHE_REF:-main}"
dir="$(cd "$(dirname "$0")/.." && pwd)/.eukhe"

if [ ! -d "$dir/.git" ]; then
  git init -q "$dir"
  git -C "$dir" remote add origin https://github.com/gildrb/eukhe
fi
git -C "$dir" fetch -q --depth 1 origin "$ref"
git -C "$dir" checkout -q --force --detach FETCH_HEAD
git -C "$dir" clean -q -f -d -x
git -C "$dir" log -1 --format="eukhe $ref: %H %s"
