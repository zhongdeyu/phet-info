#!/bin/bash

mv .repos .repos.old

if [[ $2 == '' ]]
then
    read -p "Github Username: " username
    read -sp "Github Password: " password
    echo ''
    creds=${username}:${password}
else
    creds=${1}:${2}
fi

curl -is -u "$creds" https://api.github.com/orgs/phetsims/repos -o .response

pageExtractor='s/.*page=\([0-9]\).*/\1/g'

# next
nextPage=`cat .response | grep Link: | awk '{print $2}' | sed ${pageExtractor}`
# last
lastPage=`cat .response | grep Link: | awk '{print $4}' | sed ${pageExtractor}`

nameExtractor='s/"\([a-zA-Z0-9-]*\)",/\1/'
nameMatcher="^\ \ \ \ \"name\""

# Add repos to list
cat .response | grep "${nameMatcher}" | awk '{print $2}' | sed ${nameExtractor} >> .repos

for ((i=$nextPage;i<=$lastPage;i++))
do
    curl -is -u "$creds" https://api.github.com/orgs/phetsims/repos?page=${i} -o .response
    cat .response | grep "${nameMatcher}" | awk '{print $2}' | sed ${nameExtractor} >> .repos
done

sort -f .repos -o .repos

rm .response .repos.old

