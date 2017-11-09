#!/bin/bash
STAMP=$(date +"%y%m%d %H:%M")
DBMIGRATE=0
WEBCLIENT=0
CACHEWIPE=0
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
	if [[ "$(git diff-tree --no-commit-id --name-only -r $commit | grep -E '^db/' | wc -l)" != "0" ]]
	then
	        DBMIGRATE=1
	        break
	fi
done
if [ "$DBMIGRATE" == "1" ]
then
	echo "will need to migrate"
else
	echo "not needed"
fi


echo -n " - cache wipeout ... "
for commit in $commits
do
        if [[ "$(git diff-tree --no-commit-id --name-only -r $commit | grep -E '(css|less|sass|js)' | wc -l)" != "0" ]]
        then
                DBMIGRATE=1
                break
        fi
done


if [ "$CACHEWIPE" == "1" ]
then
        echo "will need to clean"
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
else
        echo "not needed"
fi

