FROM mcr.microsoft.com/devcontainers/base:ubuntu

# Install dependencies for Determinate Nix installer
RUN apt-get update && export DEBIAN_FRONTEND=noninteractive \
    && apt-get -y install --no-install-recommends curl xz-utils sudo ca-certificates \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Install Determinate Nix
RUN curl -fsSL https://install.determinate.systems/nix | sh -s -- install linux \
    --extra-conf "sandbox = false" \
    --init none \
    --no-confirm

ENV PATH="${PATH}:/nix/var/nix/profiles/default/bin"
