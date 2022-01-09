FROM ghcr.io/linuxserver/code-server

RUN apt update && \
    apt -y install \
          python3 \
          python3-pip

RUN curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl" && \
    install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl
