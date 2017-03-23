# Creates pseudo distributed hadoop 2.7.3
#
# docker build -t matnar/hadoop .

FROM ubuntu:16.04
USER root

# install dev tools
RUN apt-get update
RUN apt-get install -y curl tar sudo openssh-server rsync default-jre vim net-tools

# passwordless ssh
RUN ssh-keygen -q -N "" -t rsa -f /root/.ssh/id_rsa 
RUN cp /root/.ssh/id_rsa.pub /root/.ssh/authorized_keys

# # java
ENV JAVA_HOME /usr/lib/jvm/java-8-openjdk-amd64/jre
ENV PATH $PATH:$JAVA_HOME/bin

# # hadoop
RUN wget http://it.apache.contactlab.it/hadoop/common/hadoop-2.7.3/hadoop-2.7.3.tar.gz ; tar -zxf hadoop-2.7.3.tar.gz -C /usr/local/ ; rm hadoop-2.7.3.tar.gz
RUN cd /usr/local && ln -s ./hadoop-2.7.3 hadoop
# 
ENV HADOOP_PREFIX /usr/local/hadoop
ENV HADOOP_COMMON_HOME /usr/local/hadoop
ENV HADOOP_HDFS_HOME /usr/local/hadoop
ENV HADOOP_HOME /usr/local/hadoop
ENV HADOOP_MAPRED_HOME /usr/local/hadoop
ENV HADOOP_YARN_HOME /usr/local/hadoop
ENV HADOOP_CONF_DIR /usr/local/hadoop/etc/hadoop
ENV YARN_CONF_DIR $HADOOP_PREFIX/etc/hadoop
ENV PATH $PATH:$HADOOP_HOME/bin

# 
RUN sed -i '/^export JAVA_HOME/ s:.*:export JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64/jre\nexport HADOOP_PREFIX=/usr/local/hadoop\nexport HADOOP_HOME=/usr/local/hadoop\n:' $HADOOP_PREFIX/etc/hadoop/hadoop-env.sh
RUN sed -i '/^export HADOOP_CONF_DIR/ s:.*:export HADOOP_CONF_DIR=/usr/local/hadoop/etc/hadoop/:' $HADOOP_PREFIX/etc/hadoop/hadoop-env.sh

# # pseudo distributed
ADD config/core-site.xml $HADOOP_PREFIX/etc/hadoop/core-site.xml
ADD config/hdfs-site.xml $HADOOP_PREFIX/etc/hadoop/hdfs-site.xml
ADD config/slaves $HADOOP_PREFIX/etc/hadoop/slaves 
# 
ADD config/ssh_config /root/.ssh/config
RUN chmod 600 /root/.ssh/config
RUN chown root:root /root/.ssh/config
# 
ADD config/bootstrap.sh /usr/local/bootstrap.sh
RUN chown root:root /usr/local/bootstrap.sh
RUN chmod 700 /usr/local/bootstrap.sh
# 
ENV BOOTSTRAP /usr/local/bootstrap.sh
# 
CMD /usr/local/bootstrap.sh

# # Hdfs ports
EXPOSE 50010 50020 50070 50075 50090 8020 9000
# # Mapred ports
# EXPOSE 10020 19888
# #Yarn ports
# EXPOSE 8030 8031 8032 8033 8040 8042 8088
# #Other ports
# EXPOSE 49707 2122
#
# SSH
EXPOSE 22
