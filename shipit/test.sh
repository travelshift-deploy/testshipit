#!/bin/bash
echo "Testing deploy scripts invocation"
pwd
git --no-pager log
echo "============"
git --no-pager log --merges --reverse
echo "============"
echo  "ENV"
env
