#!/bin/bash
DEPLOYUSER=shipit
DEPLOYHOST=deploybox
COMMAND="/usr/local/lib/toolbox/deployment/git-update-servers-v2.sh -d"
SSH=$(which ssh)
echo "----------------------------------------------------------------------------"
echo "Invoking database migration from deploybox as the deploy or rollback requires"
$SSH $DEPLOYUSER@$DEPLOYHOST "echo test. COMMAND should be $COMMAND"

