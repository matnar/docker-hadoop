# Creates pseudo distributed hadoop 3.3.2
#
# docker build -t matnar/hadoop:3.3.2 .

FROM ubuntu:18.04
USER root

# install dev tools
RUN apt-get update
RUN apt-get install -y curl tar sudo openssh-server rsync openjdk-8-jre-headless vim net-tools

# passwordless ssh
RUN ssh-keygen -q -N "" -t rsa -f /root/.ssh/id_rsa 
RUN cp /root/.ssh/id_rsa.pub /root/.ssh/authorized_keys

# # java
ENV JAVA_HOME /usr/lib/jvm/default-java
ENV PATH $PATH:$JAVA_HOME/bin

# # hadoop
RUN wget https://downloads.apache.org/hadoop/common/hadoop-3.3.2/hadoop-3.3.2.tar.gz ; tar -zxf hadoop-3.3.2.tar.gz -C /usr/local/ ; rm hadoop-3.3.2.tar.gz
RUN cd /usr/local && ln -s ./hadoop-3.3.2 hadoop


# 
ENV HADOOP_COMMON_HOME /usr/local/hadoop
ENV HADOOP_HDFS_HOME /usr/local/hadoop
ENV HADOOP_HOME /usr/local/hadoop
ENV HADOOP_MAPRED_HOME /usr/local/hadoop
ENV HADOOP_YARN_HOME /usr/local/hadoop
ENV HADOOP_CONF_DIR /usr/local/hadoop/etc/hadoop
ENV YARN_CONF_DIR $HADOOP_HOME/etc/hadoop
ENV PATH $PATH:$HADOOP_HOME/bin
ENV HDFS_NAMENODE_USER "root"
ENV HDFS_DATANODE_USER "root"
ENV HDFS_SECONDARYNAMENODE_USER "root"
ENV YARN_RESOURCEMANAGER_USER "root"
ENV YARN_NODEMANAGER_USER "root"

# # pseudo distributed
ADD config/hadoop-env.sh $HADOOP_HOME/etc/hadoop/hadoop-env.sh
ADD config/core-site.xml $HADOOP_HOME/etc/hadoop/core-site.xml
ADD config/hdfs-site.xml $HADOOP_HOME/etc/hadoop/hdfs-site.xml
ADD config/workers $HADOOP_HOME/etc/hadoop/workers
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
EXPOSE 9866 9867 9870 9864 9868 9820 9000 54310
# # Mapred ports
# EXPOSE 10020 19888
# #Yarn ports
# EXPOSE 8030 8031 8032 8033 8040 8042 8088
# #Other ports
# EXPOSE 49707 2122
#
# SSH
EXPOSE 22
