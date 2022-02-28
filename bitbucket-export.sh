#!/usr/bin/env bash

BITBUCKET_USER='Nickname'
BITBUCKET_PASSWORD='Password'
BITBUCKET_WORKSPACE='Workspace_name'
BITBUCKET_SLEEP='15s'

NEXT_URL="https://api.bitbucket.org/2.0/repositories/${BITBUCKET_WORKSPACE}?pagelen=10"
while [ ! -z $NEXT_URL ] && [ $NEXT_URL != "null" ]
do
  curl --request GET -u ${BITBUCKET_USER}:${BITBUCKET_PASSWORD} \
    --url $NEXT_URL \
    --header 'Accept: application/json' > repo_info.json

  jq -r '.values[] | {slug:.slug, links:.links.clone[] } | select(.links.name=="ssh") | "git clone \(.links.href) \(.slug)"' repo_info.json >> repo_clone_urls.txt
  # Cloning repositories
  # for repo in `repo_clone_urls`
  # do
  #   echo "Cloning" ${repo}
  #   eval ${repo}
  #   sleep ${BITBUCKET_SLEEP}
  # done

  NEXT_URL=`jq -r '.next' repo_info.json`

  sleep ${BITBUCKET_SLEEP}
  echo 'Next url: '${NEXT_URL}
done
echo 'Script successfull completed!'