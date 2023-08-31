#!/usr/bin/bash

# Use this script to select a Jira issue and add its issue id to a new git
# commit, enabling Bitbucket's smart commit feature.

# Required env variables you may provide by the .jiraenv file:
#
# $DOMAIN -> The domain of your Jira Cloud instance
# $EMAIL -> Your Jira account's email address 
# $TOKEN -> Tour Jira account's API Token

source ${HOME}/.jiraenv

# Filter for your issues in any currently open sprint
JQL="assignee = currentUser() AND type != Epic AND sprint in openSprints() ORDER BY status ASC"

URL="https://${DOMAIN}/rest/api/3/search" 
USER="$EMAIL:$TOKEN"
PARAMETER="jql=$JQL"
HEADER="Accept: application/json"

RESULT=$(curl --request GET \
	-G \
	-s \
	--user "$USER" \
	--url "$URL" \
	--data-urlencode "$PARAMETER" \
	--data-urlencode "fields=parent,summary,status" \
	--header "$HEADER" \
	| jq -r '([.issues[].fields.parent.fields.summary | length] | max) as $maxlen | .issues[] | @text "\(.key) -- \(.fields.status.name | if . == "Done" then "󰄲" elif . == "Resolved" then "󰱒" elif . == "In Progress" then "" elif "To-Do" then "󰄱" else . end) -- [\(.fields.parent.fields.summary | . + (. | length | $maxlen - .) * ".")] -- \(.fields.summary)"' \
	|fzf
) 
RESULT_ARRAY=($RESULT)
ISSUE_ID=${RESULT_ARRAY[0]}
TEMP_TEMPLATE="/tmp/tempcommit"

echo "$ISSUE_ID "$'\n\n\n#Referenced Issue:\n'"#$RESULT" > $TEMP_TEMPLATE

git commit -t $TEMP_TEMPLATE

rm $TEMP_TEMPLATE
