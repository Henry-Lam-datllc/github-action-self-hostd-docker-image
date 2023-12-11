# # hadolint ignore=DL3007
# FROM hunglam2501/henrylt:latest
# LABEL maintainer="myoung34@my.apsu.edu"

# ENV AGENT_TOOLSDIRECTORY=/opt/hostedtoolcache
# RUN mkdir -p /opt/hostedtoolcache

# ARG GH_RUNNER_VERSION="2.311.0"

# ARG TARGETPLATFORM

# SHELL ["/bin/bash", "-o", "pipefail", "-c"]

# WORKDIR /actions-runner
# COPY install_actions.sh /actions-runner

# RUN chmod +x /actions-runner/install_actions.sh \
#   && /actions-runner/install_actions.sh ${GH_RUNNER_VERSION} ${TARGETPLATFORM} \
#   && rm /actions-runner/install_actions.sh \
#   && chown runner /_work /actions-runner /opt/hostedtoolcache

# COPY token.sh entrypoint.sh app_token.sh /
# RUN chmod +x /token.sh /entrypoint.sh /app_token.sh

# ENTRYPOINT ["/entrypoint.sh"]
# CMD ["./bin/Runner.Listener", "run", "--startuptype", "service"]
# Use a base image that matches the runner's operating system and architecture.
# For example, if you are using Linux ARM64 as shown in the screenshot:
FROM ubuntu:20.04

# Set the environment variable for the runner's version.
# Make sure to use the version shown in your screenshot or the latest available.
ENV RUNNER_VERSION="2.311.0"

# Install necessary dependencies for the GitHub Runner and any additional tools you require.
RUN apt-get update && apt-get install -y \
    curl \
    sudo \
    git \
    jq \
    tar \
    && rm -rf /var/lib/apt/lists/*

# Create a user for the runner and give it the necessary permissions.
# Replace 'runner' with your preferred user name.
RUN useradd -m runner && \
    echo "runner ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

# Set up the runner directory.
RUN mkdir /actions-runner && chown -R runner /actions-runner

# Set the working directory.
WORKDIR /actions-runner

# Switch to the runner user.
USER runner

# # Download the runner package.
# RUN curl -o actions-runner-linux-arm64-${RUNNER_VERSION}.tar.gz -L \
#     https://github.com/actions/runner/releases/download/v${RUNNER_VERSION}/actions-runner-linux-arm64-${RUNNER_VERSION}.tar.gz \
#     && tar xzf ./actions-runner-linux-arm64-${RUNNER_VERSION}.tar.gz \
#     && rm actions-runner-linux-arm64-${RUNNER_VERSION}.tar.gz

# # Optional: Validate the hash.
# # The hash in the following line should match the one provided by GitHub in your screenshot.
# # Ensure that the SHA256 hash matches the one for your downloaded version.
# RUN echo "SHA256_HASH actions-runner-linux-arm64-${RUNNER_VERSION}.tar.gz" | shasum -a 256 -c

# Expose necessary ports (if any)
# For example, if you need to expose port 8080 for a web application, uncomment the next line.
# EXPOSE 8080

# Set the entrypoint to the runner's run script.
# This will initiate the runner when the container starts.
ENTRYPOINT ["./run.sh"]
