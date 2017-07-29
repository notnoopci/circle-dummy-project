SHELL := /bin/bash

prepare:
	echo JOB_ID IS $(JOB_ID)
	echo PUBLIC IP IS $(shell curl ipecho.net/plain)
	sudo apt-get update; sudo apt-get install eatmydata sysbench mysql-client
	sudo mkdir -p /myvolume/test
	sudo chown $(shell whoami):$(shell whoami) /myvolume/test
	mysql -u root -h 127.0.0.1 -e 'create database sbtest;'


####### cpu test
cpu:
	time sysbench --test=cpu --cpu-max-prime=20000 run

####### io tests
# plain
io_plain: TEST_DIR=io_plain
io_plain: FILE_SIZE=15
io_plain:
	echo ============= $(TEST_DIR)
	mkdir -p $(TEST_DIR)
	cd $(TEST_DIR); time $(COMMAND_PREFIX) sysbench --test=fileio --file-total-size=$(FILE_SIZE)G prepare
	cd $(TEST_DIR); time $(COMMAND_PREFIX) sysbench --test=fileio --file-total-size=$(FILE_SIZE)G --file-test-mode=rndrw --init-rng=on --max-time=300 --max-requests=0 run
	cd $(TEST_DIR); time $(COMMAND_PREFIX) sysbench --test=fileio --file-total-size=$(FILE_SIZE)G cleanup

io_plain_eatmydata: TEST_DIR=io_plain_eatmydata
io_plain_eatmydata: FILE_SIZE=15
io_plain_eatmydata: COMMAND_PREFIX=eatmydata
io_plain_eatmydata:
	echo ============= $(TEST_DIR)
	mkdir -p $(TEST_DIR)
	cd $(TEST_DIR); time $(COMMAND_PREFIX) sysbench --test=fileio --file-total-size=$(FILE_SIZE)G prepare
	cd $(TEST_DIR); time $(COMMAND_PREFIX) sysbench --test=fileio --file-total-size=$(FILE_SIZE)G --file-test-mode=rndrw --init-rng=on --max-time=300 --max-requests=0 run
	cd $(TEST_DIR); time $(COMMAND_PREFIX) sysbench --test=fileio --file-total-size=$(FILE_SIZE)G cleanup

# with docker volume
io_volume: TEST_DIR=/myvolume/test/io_volume
io_volume: FILE_SIZE=15
io_volume:
	echo ============= $(TEST_DIR)
	mkdir -p $(TEST_DIR)
	cd $(TEST_DIR); time $(COMMAND_PREFIX) sysbench --test=fileio --file-total-size=$(FILE_SIZE)G prepare
	cd $(TEST_DIR); time $(COMMAND_PREFIX) sysbench --test=fileio --file-total-size=$(FILE_SIZE)G --file-test-mode=rndrw --init-rng=on --max-time=300 --max-requests=0 run
	cd $(TEST_DIR); time $(COMMAND_PREFIX) sysbench --test=fileio --file-total-size=$(FILE_SIZE)G cleanup


io_volume_eatmydata: TEST_DIR=/myvolume/test/io_volume_eatmydata
io_volume_eatmydata: FILE_SIZE=15
io_volume_eatmydata: COMMAND_PREFIX=eatmydata
io_volume_eatmydata:
	echo ============= $(TEST_DIR)
	mkdir -p $(TEST_DIR)
	cd $(TEST_DIR); time $(COMMAND_PREFIX) sysbench --test=fileio --file-total-size=$(FILE_SIZE)G prepare
	cd $(TEST_DIR); time $(COMMAND_PREFIX) sysbench --test=fileio --file-total-size=$(FILE_SIZE)G --file-test-mode=rndrw --init-rng=on --max-time=300 --max-requests=0 run
	cd $(TEST_DIR); time $(COMMAND_PREFIX) sysbench --test=fileio --file-total-size=$(FILE_SIZE)G cleanup

# with memory
io_shm: TEST_DIR=/dev/shm/io_volume
io_shm: FILE_SIZE=3
io_shm:
	echo ============= $(TEST_DIR)
	mkdir -p $(TEST_DIR)
	cd $(TEST_DIR); time $(COMMAND_PREFIX) sysbench --test=fileio --file-total-size=$(FILE_SIZE)G prepare
	cd $(TEST_DIR); time $(COMMAND_PREFIX) sysbench --test=fileio --file-total-size=$(FILE_SIZE)G --file-test-mode=rndrw --init-rng=on --max-time=300 --max-requests=0 run
	cd $(TEST_DIR); time $(COMMAND_PREFIX) sysbench --test=fileio --file-total-size=$(FILE_SIZE)G cleanup

io_shm_eatmydata: TEST_DIR=/dev/shm/io_volume_eatmydata
io_shm_eatmydata: FILE_SIZE=3
io_shm_eatmydata: COMMAND_PREFIX=eatmydata
io_shm_eatmydata:
	echo ============= $(TEST_DIR)
	mkdir -p $(TEST_DIR)
	cd $(TEST_DIR); time $(COMMAND_PREFIX) sysbench --test=fileio --file-total-size=$(FILE_SIZE)G prepare
	cd $(TEST_DIR); time $(COMMAND_PREFIX) sysbench --test=fileio --file-total-size=$(FILE_SIZE)G --file-test-mode=rndrw --init-rng=on --max-time=300 --max-requests=0 run
	cd $(TEST_DIR); time $(COMMAND_PREFIX) sysbench --test=fileio --file-total-size=$(FILE_SIZE)G cleanup

MYSQL_USER=root

io: io_plain io_plain_eatmydata io_volume io_volume_eatmydata io_shm io_shm_eatmydata

####### MySQL tests
mysql:
	time sysbench --test=oltp --mysql-table-engine=innodb --oltp-table-size=1000000 --mysql-user=root --mysql-host=127.0.0.1 prepare
	time sysbench --num-threads=4 --max-time=900 --max-requests=500000 --test=oltp --oltp-table-size=80000000 --mysql-user=root --mysql-table-engine=innodb --oltp-test-mode=complex --mysql-host=127.0.0.1 run
	time sysbench --num-threads=4 --max-time=900 --max-requests=500000 --test=oltp --oltp-table-size=80000000 --mysql-user=root --mysql-table-engine=innodb --oltp-test-mode=complex --mysql-host=127.0.0.1 cleanup

####### MySQL tests
all: prepare cpu io mysql
