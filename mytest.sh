#!/bin/bash
set -exu

(while true; do echo hi; sleep 2; done) &

sleep 10
exit 0
