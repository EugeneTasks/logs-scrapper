
FROM fluent/fluentd:v1.16-debian-1

USER root

RUN fluent-gem install fluent-plugin-grafana-loki

USER fluent
# FROM fluent/fluentd:v1.16-1

# USER root

# RUN gem install fluent-plugin-grafana-loki --no-document

# RUN chown -R fluent:fluent /usr/lib/ruby/gems/3.1.0

# USER fluent

# FROM fluent/fluentd:v1.16-1

# USER root

# RUN fluent-gem install fluent-plugin-grafana-loki -v "1.2.20"

# USER fluent
