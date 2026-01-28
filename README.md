# Carbonio Certbot

Carbonio Certbot is an ACME client package for the Carbonio platform, providing automated SSL/TLS certificate management through Let's Encrypt or other ACME-compatible certificate authorities.

## Quick Start

### Prerequisites

- Docker or Podman installed
- Make

### Building Packages

```bash
# Build packages for Ubuntu 22.04
make build TARGET=ubuntu-jammy

# Build packages for Rocky Linux 9
make build TARGET=rocky-9

# Build packages for Ubuntu 24.04
make build TARGET=ubuntu-noble
```

### Supported Targets

- `ubuntu-jammy` - Ubuntu 22.04 LTS
- `ubuntu-noble` - Ubuntu 24.04 LTS
- `rocky-8` - Rocky Linux 8
- `rocky-9` - Rocky Linux 9

### Configuration

You can customize the build by setting environment variables:

```bash
# Use a specific container runtime
make build TARGET=ubuntu-jammy CONTAINER_RUNTIME=docker

# Use a different output directory
make build TARGET=rocky-9 OUTPUT_DIR=./my-packages
```

## Installation

This package is distributed as part of the [Carbonio platform](https://zextras.com/carbonio). To install:

### Ubuntu (Jammy/Noble)

```bash
apt-get install carbonio-certbot
```

### Rocky Linux (8/9)

```bash
yum install carbonio-certbot
```

## Usage

After installation, the `certbot` command is available at `/opt/zextras/common/bin/certbot`.

### Obtaining a Certificate

```bash
/opt/zextras/common/bin/certbot certonly --webroot -w /opt/zextras/.well-known/acme-challenge -d yourdomain.com
```

### Automatic Renewal

The package includes a systemd timer that automatically renews certificates:

```bash
# Enable automatic renewal
systemctl enable carbonio-certbot.timer
systemctl start carbonio-certbot.timer

# Check timer status
systemctl status carbonio-certbot.timer
```

### Manual Renewal

```bash
/opt/zextras/common/bin/certbot renew
```

## Contributing

See [CONTRIBUTING.md](CONTRIBUTING.md) for information on how to contribute to this project.

## License

The build scripts, patches, and configuration files in this repository are licensed under the GNU Affero General Public License v3.0 - see the [LICENSE.md](LICENSE.md) file for details.