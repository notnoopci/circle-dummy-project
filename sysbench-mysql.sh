#!/bin/bash
export MYSQL_USER=${MYSQL_USER:-$(whoami)}
export ADDITIONAL_ARGS=${ADDITIONAL_ARGS:-}

time sysbench --test=oltp --mysql-table-engine=innodb --oltp-table-size=1000000 --mysql-user=${MYSQL_USER} $ADDITIONAL_ARGS prepare
time sysbench --num-threads=4 --max-time=900 --max-requests=500000 --test=oltp --oltp-table-size=80000000 --mysql-user=${MYSQL_USER} --mysql-table-engine=innodb --oltp-test-mode=complex $ADDITIONAL_ARGS run
time sysbench --num-threads=4 --max-time=900 --max-requests=500000 --test=oltp --oltp-table-size=80000000 --mysql-user=${MYSQL_USER} --mysql-table-engine=innodb --oltp-test-mode=complex $ADDITIONAL_ARGS cleanup
