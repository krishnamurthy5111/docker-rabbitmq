FROM srinivasachalla/docker-ubuntu
MAINTAINER Srinivasa Reddy Challa <srinivasa.challa@sap.com>


# Install wget, erlang 19.3 & RabbitMQ 3.6.15-1
RUN DEBIAN_FRONTEND=noninteractive && \
    cd /tmp && \
    apt-get update && \
    apt-get install wget && \
    wget http://www.rabbitmq.com/rabbitmq-signing-key-public.asc && \
    apt-key add rabbitmq-signing-key-public.asc && \
    echo "deb http://www.rabbitmq.com/debian/ testing main" | tee /etc/apt/sources.list.d/rabbitmq.list && \
    wget http://packages.erlang-solutions.com/erlang-solutions_1.0_all.deb && \
    dpkg -i erlang-solutions_1.0_all.deb && \
    apt-get update && \
    apt-get -y install esl-erlang=1:19.3 && \
    apt-get install -y --force-yes rabbitmq-server=3.6.15-1 && \
    rabbitmq-plugins enable rabbitmq_management && \
    rabbitmq-plugins enable rabbitmq_jms_topic_exchange && \
    rabbitmq-plugins enable rabbitmq_stomp && \
    rabbitmq-plugins enable rabbitmq_web_stomp && \
    rabbitmq-plugins enable rabbitmq_mqtt && \
    rabbitmq-plugins enable rabbitmq_web_mqtt && \
    service rabbitmq-server stop && \
    apt-get install --yes runit && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

## remove wget
RUN apt-get remove wget -y
# Add scripts
ADD scripts /scripts
RUN chmod +x /scripts/*.sh
RUN touch /.firstrun

# Command to run
ENTRYPOINT ["/scripts/run.sh"]
CMD [""]

# Expose listen port
EXPOSE 5672
EXPOSE 15672
EXPOSE 61613
EXPOSE 15674
EXPOSE 1883
EXPOSE 15675

# Expose our log volumes
VOLUME ["/data"]
