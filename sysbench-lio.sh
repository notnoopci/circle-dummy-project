#!/bin/bash
export SIZE=${SIZE:-15}
time sysbench --test=fileio --file-total-size=${SIZE}G prepare
time sysbench --test=fileio --file-total-size=${SIZE}G --file-test-mode=rndrw --init-rng=on --max-time=300 --max-requests=0 run
time sysbench --test=fileio --file-total-size=${SIZE}G cleanup

