#!/bin/bash
DEPLOYUSER=shipit
DEPLOYHOST=deploybox
COMMAND="/usr/local/lib/toolbox/deployment/git-update-servers-v2.sh -b"
SSH=$(which ssh)
echo "----------------------------------------------------------------------------"
echo "Invoking cache wipeout from deploybox as the deploy or rollback requires"
$SSH $DEPLOYUSER@$DEPLOYHOST "echo test. COMMAND should be $COMMAND"
