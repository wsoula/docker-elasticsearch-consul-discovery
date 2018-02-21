FROM docker.elastic.co/elasticsearch/elasticsearch:6.2.1
RUN /usr/share/elasticsearch/bin/elasticsearch-plugin install -b https://github.com/vvanholl/elasticsearch-consul-discovery/releases/download/6.2.1.0/elasticsearch-consul-discovery-6.2.1.0.zip
RUN curl -OL https://releases.hashicorp.com/consul/1.0.6/consul_1.0.6_linux_amd64.zip && \
unzip consul_1.0.6_linux_amd64.zip && \
mv consul /usr/local/bin/consul && \
mkdir /var/lib/consul
COPY docker-entrypoint.sh /usr/local/bin/docker-entrypoint.sh
COPY service.json.template /var/lib/consul
# Below is from elasticsearch Dockerfile as we are using a copy of their entrypoint
# Openshift overrides USER and uses ones with randomly uid>1024 and gid=0
# Allow ENTRYPOINT (and ES) to run even with a different user
RUN chgrp 0 /usr/local/bin/docker-entrypoint.sh && \
    chmod g=u /etc/passwd && \
    chmod 0775 /usr/local/bin/docker-entrypoint.sh

ENTRYPOINT ["/usr/local/bin/docker-entrypoint.sh"]
