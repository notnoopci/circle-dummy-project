FROM circleci/golang:1.8

RUN sudo apt-get update && sudo apt-get install -y eatmydata sysbench mysql-client

VOLUME /myvolume

