#!/usr/bin/env bash

WORKING_DIR="/path/to/git/repo"
DEPLOY_KEY="/path/to/deploy.key"

# Check to make sure that the deploy key exists.
if [[ ! -f "$DEPLOY_KEY" ]]; then
    echo "Unable to find deploy key in $DEPLOY_KEY"
    exit 1
fi

# Change to the Github project.
cd "$WORKING_DIR" || exit

echo "Getting current Git head."
OLD_HEAD=$(git rev-parse HEAD)

echo "Doing a Git pull."
ssh-add bash -c 'ssh-add $DEPLOY_KEY; OUTCOME=$(git pull); TIME_STAMP=$(date); echo $TIME_STAMP "-" $OUTCOME' >> /var/log/git-update.log

echo "Getting new Git head."
NEW_HEAD=$(git rev-parse HEAD)

echo "Checking to see if there has been any updates."
if [[ "$NEW_HEAD" != "$OLD_HEAD" ]]; then
    echo "Updates have been pulled."
    # Do other things here.
    # e.g. pip install
    # service nginx restart
fi