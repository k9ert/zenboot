#!/bin/bash

. sanitycheck_functions.sh

NODENAME=127.0.0.1
PORT=8080

URL="http://${NODENAME}:${PORT}/zenboot/rest/sanitycheck"

test_setup
# First call it to verify that this job get created
assert_http_code $URL 201 "POST" "Accept: text/xml" "sanitycheck:sanitycheck"

echo "# Make a second call "
RETURNVALUE=`curl -sL  --write-out '%{http_code}' --request POST --max-time 5 --basic --user 'sanitycheck:sanitycheck' -H 'Accept: text/xml' http://127.0.0.1:8080/zenboot/rest/sanitycheck`
echo "RETURNVALUE:-----------------------------------------------------"
echo $RETURNVALUE
echo "END--------------------------------------------------------------"

CALLBACK=`echo $RETURNVALUE | sed "s/.*<referral>//" | sed "s/<\/referral>.*//"`
echo "# CALLBACK is $CALLBACK"
sleep 1
assert_http_response $CALLBACK "RUNNING" "-H 'Accept: text/xml' --user sanitycheck:sanitycheck"
sleep 7
assert_http_response $CALLBACK "SUCCESS" "-H 'Accept: text/xml' --user sanitycheck:sanitycheck"



test_teardown
