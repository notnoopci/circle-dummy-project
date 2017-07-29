time sysbench --test=oltp --mysql-table-engine=innodb --oltp-table-size=1000000 --mysql-user=$(whoami) prepare
time sysbench --num-threads=4 --max-time=900 --max-requests=500000 --test=oltp --oltp-table-size=80000000 --mysql-user=$(whoami) --mysql-table-engine=innodb --oltp-test-mode=complex run
time sysbench --num-threads=4 --max-time=900 --max-requests=500000 --test=oltp --oltp-table-size=80000000 --mysql-user=$(whoami) --mysql-table-engine=innodb --oltp-test-mode=complex cleanup

