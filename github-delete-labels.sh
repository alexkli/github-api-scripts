#!/usr/bin/env bash

if [ $# -lt 4 ]; then
    echo "Usage: `basename $0` <user>:<token> <github-api-url> <org/repo> <label>..."
    exit
fi

user=$1
base=$2
repo=$3

shift
shift
shift

accept="Accept: application/vnd.github.symmetra-preview+json"

echo "Deleting labels in ${repo}:"

for label in "$@"; do
    printf "%s" "+ $label"
    if curl -f -s -X DELETE -u "$user" -H "$accept" $base/repos/$repo/labels/$label; then
        echo " deleted."
    else
        echo " FAILED."
    fi
done

