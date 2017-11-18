#!/bin/bash
DEPLOYUSER=shipit
DEPLOYHOST=deploybox
COMMAND="/usr/local/lib/toolbox/deployment/webclient-rebuild.sh"
SSH=$(which ssh)
echo "----------------------------------------------------------------------------"
echo "Invoking webclient rebuild from deploybox as the deploy or rollback requires"
$SSH $DEPLOYUSER@$DEPLOYHOST "echo test. COMMAND should be $COMMAND"

