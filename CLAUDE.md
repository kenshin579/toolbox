# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

A Kubernetes debugging toolbox Docker image based on Alpine Linux, packaged with network diagnostic tools for troubleshooting applications and network connectivity in Kubernetes clusters.

## Build & Deploy Commands

```bash
# Build image locally
make build

# Build and push to registry
make build-push

# Build multi-architecture image (amd64, arm64) and push
make buildx

# Test built image (verifies tools are working)
make test

# Clean local images
make clean

# Push only (requires prior build)
make push
```

## Docker Configuration

- **Registry**: `kenshin579`
- **Image**: `toolbox`
- **Version**: Defined in `Makefile` (currently `v0.1.0`)
- **Tags**: Both versioned and `latest` tags are created

## Architecture

**Base Image**: Alpine 3.19

**Installed Tools**:
- Database clients: `mysql-client`, `redis`
- Network diagnostics: `iputils`, `traceroute`, `bind-tools`, `iproute2`, `tcpdump`, `nmap`
- HTTP utilities: `curl`, `wget`
- Shell: `bash` (default), `busybox-extras`

**Container Behavior**:
- Runs as root user (required for `tcpdump`, `nmap`)
- Working directory: `/root`
- Default shell: `/bin/bash`
- Default CMD: Interactive bash shell (override with `sleep infinity` in Kubernetes)

## Kubernetes Usage Pattern

This toolbox is designed to be deployed as a debugging pod in Kubernetes:

```bash
# Typical deployment
kubectl run toolbox --image=kenshin579/toolbox:latest --command -- sleep infinity

# Then exec into it
kubectl exec -it toolbox -- bash
```

## Version Management

Update version in `Makefile`:
```makefile
VERSION = v0.1.0
```

Both versioned tag and `latest` tag are automatically created during build.
