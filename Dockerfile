# Use the official Ubuntu base image
FROM --platform=linux/amd64 ubuntu:latest

# Set the default user
ENV USER_NAME=vscode
ENV UID=1001
ENV GID=1001
ENV GROUP_NAME=4{USER_NAME}

# Set environment variables for non-interactive apt-get
ENV DEBIAN_FRONTEND=noninteractive

# Update and upgrade the system
RUN apt-get update && apt-get upgrade -y
RUN apt-get install ca-certificates curl wget build-essential git sudo -y

# Copy the Zscaler certificate into the container
COPY path/to/local/zscaler.crt /usr/local/share/ca-certificates/zscaler.crt

# Update the CA certificates
RUN update-ca-certificates

# Configure Python to use the certificate
RUN mkdir -p /etc/pip && echo "[global]\ncert = /usr/local/share/ca-certificates/zscaler.crt" > /etc/pip/pip.conf

# Configure curl to use the certificate
RUN echo "cacert=/usr/local/share/ca-certificates/zscaler.crt" >> /etc/curlrc

# Create a group with GID 1001 and a new user 'vscode' with UID 1001, add to sudo group
RUN groupadd -g ${GID} ${GROUP_NAME} && \
    useradd -u ${UID} -g ${GROUP_NAME} -m -s /bin/bash ${USER_NAME} && \
    echo "${USER_NAME} ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

# Switch to the vscode user
USER vscode

# Install Homebrew
RUN /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# Configure wget to use the certificate
RUN echo "ca_certificate=/usr/local/share/ca-certificates/zscaler.crt" >> /etc/wgetrc

# Set Homebrew environment variables
RUN echo >> /home/vscode/.bashrc && \
    echo 'eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"' >> /home/vscode/.bashrc && \
    eval $(/home/linuxbrew/.linuxbrew/bin/brew shellenv) && \
    . ~/.bashrc && \
    brew install jq yq checkov trivy terragrunt opentofu tflint gitversion git-flow git-lfs && \
    echo "alias tf='tofu'" >> ~/.bashrc
