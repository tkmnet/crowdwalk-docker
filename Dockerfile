FROM centos:7

RUN yum -y update
RUN localedef -f UTF-8 -i en_US en_US.UTF-8

RUN yum -y install java-11-openjdk git unzip which


WORKDIR /usr/local/lib
RUN curl -O -L https://services.gradle.org/distributions/gradle-5.0-bin.zip
RUN unzip gradle-5.0-bin.zip
RUN rm -f gradle-5.0-bin.zip

RUN git clone https://github.com/crest-cassia/CrowdWalk.git
WORKDIR /usr/local/lib/CrowdWalk/crowdwalk
RUN java=`which java`;javabin=`readlink -f $java`;javabindir=`dirname $javabin`;export JAVA_HOME=`dirname $javabindir`
RUN /usr/local/lib/gradle-5.0/bin/gradle build
RUN chmod a+x quickstart.sh
RUN echo '#!/bin/sh' > /usr/local/bin/crowdwalk
RUN echo '' >> /usr/local/bin/crowdwalk
RUN echo "export CROWDWALK=`pwd`" >> /usr/local/bin/crowdwalk
RUN echo "`pwd`/quickstart.sh \$@" >> /usr/local/bin/crowdwalk
RUN chmod a+x /usr/local/bin/crowdwalk


WORKDIR /root
RUN rm -f anaconda-ks.cfg
RUN cp -r /usr/local/lib/CrowdWalk/crowdwalk/sample /sample
RUN chmod -R 777 /sample

#ENTRYPOINT "/root/simulation.sh"
