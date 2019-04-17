FROM microsoft/powershell

COPY pks /usr/local/bin
COPY get-pks-k8s-config.ps1 /usr/local/bin
RUN chmod +x /usr/local/bin/pks; \
  apt-get update && apt-get install -y apt-transport-https; \
  apt-get install -y curl && apt-get install -y gnupg2 && \
  curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add -; \
  touch /etc/apt/sources.list.d/kubernetes.list; \
  echo "deb https://apt.kubernetes.io/ kubernetes-xenial main" | tee -a /etc/apt/sources.list.d/kubernetes.list; \
  apt-get update && apt-get install -y kubectl