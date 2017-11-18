#!/bin/bash
STAMP=$(date +"%y%m%d %H:%M")
DBMIGRATE=0
WEBCLIENT=0
CACHEWIPE=0
DEPLOYUSER=shipit
DEPLOYHOST=deploybox
COMMAND="/usr/local/lib/toolbox/deployment/git-update-servers-v2.sh"
echo "$STAMP: Testing deploy scripts invocation"
echo "-----------------------------------------"
echo "LASTDEP=$LAST_DEPLOYED_SHA"
echo "CURRENT=$REVISION"
echo "-----------------------------------------"
commits=$(git log --reverse --pretty=format:"%h" $LAST_DEPLOYED_SHA...$REVISION | tr '\n' ' ')
echo "Commits in diff : $commits"
echo "Checking if optional steps needed"
echo -n " - db migrations ... "
for commit in $commits
do
	if [[ "$(git diff-tree --no-commit-id --name-only -r $commit | grep -e '^db/' -e '^migrations/'| wc -l)" != "0" ]]
	then
	        DBMIGRATE=1
	        break
	fi
done
if [ "$DBMIGRATE" == "1" ]
then
	echo "will need to migrate"
	$COMMAND="$COMMAND -d"
else
	echo "not needed"
fi


echo -n " - cache wipeout ... "
for commit in $commits
do
        if [[ "$(git diff-tree --no-commit-id --name-only -r $commit | grep -E '(css|less|sass|js)' | wc -l)" != "0" ]]
        then
                CACHEWIPE=1
                break
        fi
done


if [ "$CACHEWIPE" == "1" ]
then
        echo "will need to clean"
	COMMAND="$COMMAND -b"
else
        echo "not needed"
fi

echo -n " - webclient rebuild ... "
for commit in $commits
do
        if [[ "$(git diff-tree --no-commit-id --name-only -r $commit | grep -E 'webclient/' | wc -l)" != "0" ]]
        then
                WEBCLIENT=1
                break
        fi
done


if [ "$WEBCLIENT" == "1" ]
then
        echo "will need to rebuild"
	shipit/webclient_rebuild.sh
else
        echo "not needed"
fi

echo "Final command = ssh $DEPLOYUSER@$DEPLOYBOX \"$COMMAND\""

