FROM docker:dind

# Environment variables
ENV DOCKER_CI_VERSION 1.0.0
ENV GLIBC_VER '2.31-r0'

# Install prerequisites
RUN apk --no-cache add binutils curl
RUN curl -sL https://alpine-pkgs.sgerrand.com/sgerrand.rsa.pub -o /etc/apk/keys/sgerrand.rsa.pub && \
    curl -sLO https://github.com/sgerrand/alpine-pkg-glibc/releases/download/${GLIBC_VER}/glibc-${GLIBC_VER}.apk && \
    curl -sLO https://github.com/sgerrand/alpine-pkg-glibc/releases/download/${GLIBC_VER}/glibc-bin-${GLIBC_VER}.apk
RUN apk add --no-cache glibc-${GLIBC_VER}.apk glibc-bin-${GLIBC_VER}.apk
    
# Install AWS CLI
RUN curl -sL https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip -o awscliv2.zip && \
    unzip awscliv2.zip && \
    aws/install

# Remove unwanted files
RUN rm -rf awscliv2.zip aws /usr/local/aws-cli/v2/*/dist/aws_completer /usr/local/aws-cli/v2/*/dist/awscli/data/ac.index /usr/local/aws-cli/v2/*/dist/awscli/examples && \
    rm glibc-${GLIBC_VER}.apk && \
    rm glibc-bin-${GLIBC_VER}.apk && \
    rm -rf /var/cache/apk/*

# Install Copilot CLI
RUN curl -Lo /usr/local/bin/copilot https://github.com/aws/copilot-cli/releases/download/v0.1.0/copilot-linux-v0.1.0 && \
    chmod +x /usr/local/bin/copilot
