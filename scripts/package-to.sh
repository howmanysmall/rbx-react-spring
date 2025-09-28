#!/usr/bin/env bash

location="$1"

if [[ -z "${location}" ]]; then
	echo "Usage: $0 <to-location>"
	exit 1
fi

if [[ ! -d "${location}" ]]; then
	echo "Error: Destination '${location}' is not a directory."
	exit 1
fi

echo "Processing to ${location}..."
bun x --bun rbxtsc
npm pack --pack-destination "${location}"
