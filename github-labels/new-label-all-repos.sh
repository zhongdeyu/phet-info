#!/bin/bash

# new-label-all-repos.sh
#
# This file adds a new label to all repos

if [[ $1 = '' ]] || [[ $2 = '' ]]
then
  echo "Usage: $0 label-name color"
  exit 1
else
  name=$1
  color=$2
  label={\"name\":\"$1\",\"color\":\"$2\"}
  echo "$label"
fi

read -p "Github Username: " username
read -sp "Github Password: " password
echo ''
creds=${username}:${password}

./update-repos-list.sh ${username} ${password}

echo 'For each repo, this script should print "201 Created" to indicate success"'

for repo in `cat .repos`
do
  repo=`echo ${repo}`
  url=https://api.github.com/repos/phetsims/$repo/labels
  echo "Adding label to: ${repo}"
  echo "Result:"
  curl -isH 'User-Agent: "phet"' -u "$creds" -d "$label" -X POST "$url" | head -n 1
  echo ""
done

echo ${name},${color} >> github-labels
sort github-labels -o github-labels
git pull && git commit github-labels -m "Added github label from ${label}" && git push

echo "Complete."
