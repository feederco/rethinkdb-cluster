#!/bin/bash

JOINS=`getent hosts tasks.rethinkdb | awk '{ print $1 }' | sed -e 's/^/--join /' | tr '\n' ' '`
echo "Starting rethinkdb using $JOINS"
rethinkdb --bind all --no-http-admin $JOINS
