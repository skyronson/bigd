FROM jupyter/datascience-notebook:x86_64-python-3.8

COPY ./requirements.txt /tmp/requirements.txt
RUN pip install -r /tmp/requirements.txt

USER root

RUN apt-get update && \
    apt-get install -y openjdk-11-jdk && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

ENV JAVA_HOME /usr/lib/jvm/java-11-openjdk-amd64
ENV PATH $JAVA_HOME/bin:$PATH

RUN groupadd -g 185 spark && \
    usermod -aG spark jovyan && \
    useradd -u 185 -g spark -m -s /bin/bash spark && \
    usermod -aG users spark

USER $NB_UID
