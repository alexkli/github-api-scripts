#!/usr/bin/env bash

if [ $# -lt 3 ]; then
    echo "Usage: `basename $0` <user>:<token> <github-api-url> <org/repo>"
    exit
fi

user=$1
base=$2
repo=$3

accept="Accept: application/vnd.github.symmetra-preview+json"

labelsJson=$(curl -f -s -u "$user" -H "$accept" $base/repos/$repo/labels)

echo $labelsJson | jq .

while true; do
    read -p "Do you want to delete all these labels from $repo? y/n " yn
    case $yn in
        [Yy]* ) echo "YES"; break;;
        [Nn]* ) exit;;
        * ) echo "Please answer yes or no.";;
    esac
done

echo "Deleting:"

readarray -t labels < <(jq -c '.[] | {name: .name, description: .description, color: .color}' <<< $labelsJson)

for label in "${labels[@]}"; do
    name=$(jq -r '.name' <<< $label)
    
    printf "+ $name"
    if curl -f -s -X DELETE -u "$user" -H "$accept" $base/repos/$repo/labels/$name > /dev/null; then
        echo " deleted."
    else
        echo " FAILED."
    fi
done
