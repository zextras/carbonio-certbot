# Carbonio Certbot

Carbonio Certbot is an ACME client package for the Carbonio platform, providing automated SSL/TLS certificate management through Let's Encrypt or other ACME-compatible certificate authorities.

**Quick Start:**

```bash
# Build the package for Ubuntu 22.04
make build TARGET=ubuntu-jammy

# Build for Rocky Linux 9
make build TARGET=rocky-9

# See all available commands
make help
```

## Features

- Pre-configured Certbot installation for Carbonio
- Systemd service and timer for automatic certificate renewal
- Custom wrapper script for proper Python environment setup
- Support for multiple Linux distributions (Ubuntu, Rocky Linux)
- Integrated with Carbonio's directory structure at `/opt/zextras`

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

## Building

This package uses YAP (Yet Another Packager) in Docker/Podman containers for building. See all available build commands with `make help`.

To build for a specific distribution:

```bash
# Build for Ubuntu 22.04
make build TARGET=ubuntu-jammy

# Build for Rocky Linux 9
make build TARGET=rocky-9

# List all supported targets
make list-targets

# Clean build artifacts
make clean
```

Build artifacts will be placed in the `artifacts/` directory.

**Supported targets:** ubuntu-jammy, ubuntu-noble, rocky-8, rocky-9

## Contributing

See [CONTRIBUTING.md](CONTRIBUTING.md) for information on how to contribute to this project.

## License

The build scripts, patches, and configuration files in this repository are licensed under the GNU Affero General Public License v3.0 - see the [LICENSE.md](LICENSE.md) file for details.

This repository does not contain the source code of the third-party project it packages. The build scripts download upstream sources at build time from its original location. The upstream project retains its own licenses, and the resulting built package/s are distributed under those original licenses. Please refer to the component's upstream documentation for specific licensing information.

The packaged Certbot software itself is licensed under Apache-2.0 by the Electronic Frontier Foundation.
