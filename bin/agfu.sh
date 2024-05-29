#!/bin/bash
# Run agfu.sh in interactive on specified server

ssh $1 -t '~/bin/agfu.sh'
