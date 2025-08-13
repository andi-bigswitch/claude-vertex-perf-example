FROM alpine:3.22.1

# Allow project ID to be customized at build time
ARG VERTEX_PROJECT_ID=avalabs-sec-app-env
ENV VERTEX_PROJECT_ID=${VERTEX_PROJECT_ID}
# Install system dependencies and performance tools
RUN apk update && apk add --no-cache \
    nodejs \
    npm \
    curl \
    bash \
    python3 \
    py3-pip \
    ca-certificates \
    gnupg \
    strace \
    tcpdump \
    wireshark-common \
    tshark

# Install Claude Code CLI
RUN npm install -g @anthropic-ai/claude-code

# Install Google Cloud CLI to /opt (accessible to all users)
RUN curl -sSL https://sdk.cloud.google.com > /tmp/install_gcloud.sh && \
    bash /tmp/install_gcloud.sh --install-dir=/opt && \
    rm /tmp/install_gcloud.sh
ENV PATH=$PATH:/opt/google-cloud-sdk/bin

# Create arista user
RUN addgroup -g 1000 arista && \
    adduser -u 1000 -G arista -s /bin/bash -D arista

# Add gcloud to PATH for arista user's profile
RUN echo 'export PATH=$PATH:/opt/google-cloud-sdk/bin' >> /home/arista/.bashrc

# Copy test script
COPY test.sh /workspace/test.sh
RUN chown arista:arista /workspace/test.sh && \
    chmod +x /workspace/test.sh

# Set working directory
WORKDIR /workspace

# Switch to arista user
USER arista

# Default command
CMD ["/workspace/test.sh"]
