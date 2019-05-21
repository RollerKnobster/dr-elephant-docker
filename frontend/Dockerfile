FROM centos:7

ENV HADOOP_VERSION	2.7.1
ENV SPARK_VERSION	1.6.0
ENV HADOOP_HOME		/usr/local/hadoop
ENV PATH		$PATH:$HADOOP_HOME/bin:$HADOOP_HOME/sbin:$PATH:/activator-dist-1.3.12/bin
ENV JAVA_HOME /usr/lib/jvm/java-1.8.0
ENV HADOOP_CONF_DIR=$HADOOP_HOME/etc/hadoop
ENV ELEPHANT_CONF_DIR=/dr-elephant/app-conf


RUN yum install -y java-1.8.0-openjdk-devel wget unzip git which zip mariadb

# Activator instalation
RUN wget https://downloads.typesafe.com/typesafe-activator/1.3.12/typesafe-activator-1.3.12.zip
RUN unzip typesafe-activator-1.3.12.zip

# Hadoop Installation
RUN wget http://archive.apache.org/dist/hadoop/core/hadoop-$HADOOP_VERSION/hadoop-$HADOOP_VERSION.tar.gz  && tar -zxf /hadoop-$HADOOP_VERSION.tar.gz && \
    rm /hadoop-$HADOOP_VERSION.tar.gz && mv hadoop-$HADOOP_VERSION /usr/local/hadoop && mkdir -p /usr/local/hadoop/logs 

# Dr Elephant Instalation
RUN git clone https://github.com/RollerKnobster/dr-elephant.git dr-elephant-sources
RUN sed -i "s/hadoop_version=.*/hadoop_version=$HADOOP_VERSION/g" /dr-elephant-sources/compile.conf
RUN sed -i "s/spark_version=.*/spark_version=$SPARK_VERSION/g" /dr-elephant-sources/compile.conf
RUN sed -i "s/clean compile test \$extra_commands/clean compile/g" /dr-elephant-sources/compile.sh
#RUN sed -i "s/lazy val mysqlConnectorVersion = \"5.1.36\"/lazy val mysqlConnectorVersion = \"8.0.16\"/g" /dr-elephant-sources/project/Dependencies.scala
#RUN sed -i "s/(flow_exec_id)/(flow_exec_id(100))/g" /dr-elephant-sources/conf/evolutions/default/1.sql
#RUN sed -i "s/(job_def_id)/(job_def_id(100))/g" /dr-elephant-sources/conf/evolutions/default/1.sql
#RUN sed -i "s/(flow_def_id)/(flow_def_id(100))/g" /dr-elephant-sources/conf/evolutions/default/1.sql
#RUN sed -i "s/spark-core_2.10/spark-core_2.11/g" /dr-elephant-sources/project/Dependencies.scala
#RUN sed -i "s/sbt.version=0.13.5/sbt.version=1.0.0/g" /dr-elephant-sources/project/build.properties
#RUN sed -i "s/2.10.4/2.11.7/g" /dr-elephant-sources/build.sbt
#RUN sed -i "s/\"com.fasterxml.jackson.core\" % \"jackson-databind\" % jacksonVersion/\"com.fasterxml.jackson.core\" % \"jackson-databind\" % \"2.5.4\"/g" /dr-elephant-sources/project/Dependencies.scala
#RUN sed -i "s/\"com.fasterxml.jackson.module\" % \"jackson-module-scala\" % jacksonVersion/\"com.fasterxml.jackson.core\" % \"jackson-databind\" % \"2.5.4\"/g" /dr-elephant-sources/project/Dependencies.scala
#RUN echo "// Override invalid dependencies\ndependencyOverrides += \"com.fasterxml.jackson.core\" % \"jackson-databind\" % \"2.5.4\"\ndependencyOverrides += \"com.fasterxml.jackson.module\" % \"jackson-module-scala\" % \"2.5.4\"" >> /dr-elephant-sources/project/plugins.sbt
#RUN sed -i "s/getOrElse(\"2.2.2\"))/getOrElse(\"2.3.9\"))/g" /dr-elephant-sources/project/plugins.sbt
#RUN sed -i "s//ExclusionRule(organization = \"com.fasterxml.jackson.core\")/g"
RUN cat /dr-elephant-sources/compile.conf
RUN cd /dr-elephant-sources && ./compile.sh compile.conf &&  cd dist && unzip dr*.zip  && rm *.zip && mv $PWD/dr*/ /dr-elephant

# POST Installation
RUN sed -i 's#/dev/null#$project_root/logs/out#' /dr-elephant/bin/start.sh && mkdir -p /dr-elephant/app-conf && cp /dr-elephant-sources/app-conf/* /dr-elephant/app-conf
#RUN sed -i "s/(flow_exec_id)/(flow_exec_id(100))/g" /dr-elephant/conf/evolutions/default/1.sql
#RUN sed -i "s/(job_def_id)/(job_def_id(100))/g" /dr-elephant/conf/evolutions/default/1.sql
#RUN sed -i "s/(flow_def_id)/(flow_def_id(100))/g" /dr-elephant/conf/evolutions/default/1.sql

COPY entrypoint.sh /
COPY start.sh /

VOLUME $HADOOP_HOME/etc/hadoop/

ENTRYPOINT ["/entrypoint.sh"]
CMD ["/start.sh"]

