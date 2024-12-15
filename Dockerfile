# Use the official Ubuntu base image
FROM ubuntu:latest

# Set environment variables for non-interactive apt-get
ENV DEBIAN_FRONTEND=noninteractive

# Update and upgrade the system
RUN apt-get update && apt-get upgrade -y
RUN apt-get install jq yq ca-certificates curl python3-pip wget build-essential zip unzip file git sudo -y

# Copy the Zscaler certificate into the container
#COPY path/to/local/zscaler.crt /usr/local/share/ca-certificates/zscaler.crt

# Update the CA certificates
RUN update-ca-certificates

# Configure Python to use the certificate
#RUN mkdir -p /etc/pip && echo "[global]\ncert = /usr/local/share/ca-certificates/zscaler.crt" > /etc/pip/pip.conf

# Configure curl to use the certificate
#RUN echo "cacert=/usr/local/share/ca-certificates/zscaler.crt" >> /etc/curlrc

# Create a group with GID 1001 and a new user 'vscode' with UID 1001, add to sudo group
RUN groupadd -g 1001 vscode && useradd -m -u 1001 -g 1001 -G sudo vscode

# Allow passwordless sudo for the vscode user
RUN echo "vscode ALL=(ALL) NOPASSWD:ALL" | tee /etc/sudoers.d/vscode

# Switch to the vscode user
USER vscode

# Install Homebrew
#RUN /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# Set Homebrew environment variables
#ENV PATH="/home/vscode/.linuxbrew/bin:/home/vscode/.linuxbrew/sbin:${PATH}"
