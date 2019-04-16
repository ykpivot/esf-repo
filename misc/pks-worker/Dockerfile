FROM ubuntu
COPY pks /usr/local/bin
RUN apt-get update; \
  apt-get update && apt-get install -y curl apt-transport-https jq ruby g++ make ruby-dev git; \
  gem install cf-uaac; \
  curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add -; \
  touch /etc/apt/sources.list.d/kubernetes.list; \
  echo "deb http://apt.kubernetes.io/ kubernetes-xenial main" | tee -a /etc/apt/sources.list.d/kubernetes.list; \
  apt-get update; \
  apt-get install -y kubectl; \
  chmod +x /usr/local/bin/pks; \
  curl -o om https://github.com/pivotal-cf/om/releases/download/0.36.0/om-linux; \
  chmod +x om; \
  mv om /usr/local/bin