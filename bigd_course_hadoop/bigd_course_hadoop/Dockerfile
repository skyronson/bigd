FROM bde2020/hadoop-namenode:2.0.0-hadoop3.2.1-java8 AS namenode

RUN echo "deb http://archive.debian.org/debian stretch main contrib non-free" > /etc/apt/sources.list
RUN apt-get update && apt-get install -y python3 mc


FROM bde2020/hadoop-datanode:2.0.0-hadoop3.2.1-java8 AS datanode

RUN echo "deb http://archive.debian.org/debian stretch main contrib non-free" > /etc/apt/sources.list
RUN apt-get update && apt-get install -y python3


FROM bde2020/hadoop-resourcemanager:2.0.0-hadoop3.2.1-java8 AS resourcemanager

RUN echo "deb http://archive.debian.org/debian stretch main contrib non-free" > /etc/apt/sources.list
RUN apt-get update && apt-get install -y python3


FROM bde2020/hadoop-nodemanager:2.0.0-hadoop3.2.1-java8 AS nodemanager

RUN echo "deb http://archive.debian.org/debian stretch main contrib non-free" > /etc/apt/sources.list
RUN apt-get update && apt-get install -y python3


FROM bde2020/hadoop-historyserver:2.0.0-hadoop3.2.1-java8 AS historyserver

RUN echo "deb http://archive.debian.org/debian stretch main contrib non-free" > /etc/apt/sources.list
RUN apt-get update && apt-get install -y python3


# Этот образ построен на основе Debian bullseye
FROM apache/hive:4.0.0 AS hive

USER root
RUN apt-get update && apt-get install -y curl net-tools

