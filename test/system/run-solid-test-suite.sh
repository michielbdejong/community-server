#!/bin/bash
set -e

# Start server
npm ci
npm start &
PID=$!

# Initialize tests
pushd test/tmp
rm -rf solid-crud-tests
git clone https://github.com/solid/solid-crud-tests
cd solid-crud-tests
git checkout v5.0.0
npm ci

# Run tests
export SERVER_ROOT=http://localhost:3000
export ALICE_WEBID_DOC=${SERVER_ROOT}/profile.ttl
export ALICE_WEBID=$ALICE_WEBID_DOC#me
curl -X PUT $ALICE_WEBID_DOC -H 'Content-Type: text/turtle' -d "<$ALICE_WEBID> <http://www.w3.org/ns/pim/space#storage> </>."
npm run jest

# Clean up
kill $PID
popd