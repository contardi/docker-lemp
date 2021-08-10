FROM docker.elastic.co/elasticsearch/elasticsearch:7.9.0

RUN /usr/share/elasticsearch/bin/elasticsearch-plugin install analysis-icu && \
    /usr/share/elasticsearch/bin/elasticsearch-plugin install analysis-phonetic

