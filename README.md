# TFTP Server Docker Image

A lightweight, containerized TFTP (Trivial File Transfer Protocol) server based on Alpine Linux. Perfect for simple file transfer needs in development, testing, and embedded systems.

## Overview

TFTP is a simple, lightweight protocol used for file transfer without authentication. This container runs `tftp-hpa` (the HPA TFTP daemon) on Alpine Linux, resulting in a minimal, fast, and efficient image.

**Use cases:**
- PXE boot servers for network installations
- Firmware updates for network devices (routers, switches, etc.)
- Simple file distribution in development environments
- Boot code delivery for embedded systems
- Lab environments and testing

## Features

- **Lightweight**: Based on Alpine Linux, minimal image size
- **Multi-architecture**: Supports both `amd64` and `arm64` architectures
- **Standard TFTP**: Uses tftp-hpa, the widely-used reference implementation
- **Simple**: Minimal configuration, works out of the box
- **IPv4 support**: Configured for IPv4 connectivity

## Getting Started

### Pull the Image

```bash
docker pull ghcr.io/whadafunk/tftp:latest
```

Or use a specific version:
```bash
docker pull ghcr.io/whadafunk/tftp:1.0.0
```

### Running the Container

Basic usage with a volume for TFTP files:

```bash
docker run -d \
  --name tftp \
  --hostname tftp \
  -p 69:69/udp \
  -v /tftp_data:/var/lib/tftpd \
  ghcr.io/whadafunk/tftp:latest
```

#### Parameters Explained

| Parameter | Description |
|-----------|-------------|
| `-d` | Run in detached mode (background) |
| `--name tftp` | Container name for easy reference |
| `--hostname tftp` | Container hostname |
| `-p 69:69/udp` | Expose UDP port 69 (TFTP standard port) |
| `-v /tftp_data:/var/lib/tftpd` | Mount host directory for TFTP files |

### Docker Compose Example

Create a `docker-compose.yml` file:

```yaml
version: '3.8'

services:
  tftp:
    image: ghcr.io/whadafunk/tftp:latest
    container_name: tftp
    hostname: tftp
    ports:
      - "69:69/udp"
    volumes:
      - ./tftp_data:/var/lib/tftpd
    restart: unless-stopped
```

Then run:
```bash
docker-compose up -d
```

## TFTP Commands

Once the server is running, you can use `tftp` client on your host:

### Download a file from server
```bash
tftp localhost
tftp> get filename.txt
tftp> quit
```

### Upload a file to server
```bash
tftp localhost
tftp> put localfile.txt remotefile.txt
tftp> quit
```

Or using command-line tools:
```bash
# Download
tftp -c get remotefile.txt < /dev/null

# Upload (requires tftp-hpa client)
echo "put localfile.txt" | tftp localhost
```

## Configuration Details

### Container Startup

The container runs the TFTP daemon with these flags:

```
/usr/sbin/in.tftpd -4 -L -p /var/lib/tftpd
```

- `-4`: Use IPv4 only
- `-L`: Run in foreground mode (required for Docker containers)
- `-p /var/lib/tftpd`: Specify the TFTP root directory

### Ports and Protocols

- **Port**: UDP 69 (standard TFTP port)
- **Protocol**: UDP (stateless, connectionless)
- **Max file size**: Limited by TFTP protocol (typically 16-32 MB depending on implementation)

## Security Considerations

⚠️ **Important**: TFTP has no authentication or encryption. Use in trusted networks only.

**Best practices:**
- Don't expose TFTP to untrusted networks
- Use firewall rules to restrict access to specific IPs
- Serve read-only files when possible
- Monitor TFTP traffic for unusual activity
- Keep the volume directory properly restricted (chmod 755 or 775)

## Building from Source

Clone the repository:
```bash
git clone https://github.com/whadafunk/tftp.git
cd tftp
```

Build locally:
```bash
docker build -t tftp:local .
```

Build for specific architecture:
```bash
docker buildx build --platform linux/amd64 -t tftp:amd64 .
docker buildx build --platform linux/arm64 -t tftp:arm64 .
```

## Troubleshooting

### Connection refused / Port not accessible
- Ensure port 69/UDP is open: `netstat -un | grep 69`
- Check firewall rules on host and in containers
- Verify container is running: `docker ps | grep tftp`

### File transfer timeouts
- Check firewall is not blocking UDP 69
- Verify the TFTP client can reach the server: `ping <server-ip>`
- Try with a smaller file first

### Permission denied when uploading
- Check volume directory permissions on host
- Ensure `/var/lib/tftpd` inside container is writable
- The daemon runs as root, so permissions should be permissive

### View logs
```bash
docker logs tftp
```

## Architecture Support

This image is built for multiple architectures:
- **linux/amd64**: Standard x86-64 (Intel/AMD)
- **linux/arm64**: ARM 64-bit (Apple Silicon, ARM servers, Raspberry Pi 4+)

Docker automatically pulls the correct image for your platform.

## License

This project uses tftp-hpa from the HPA project, which is part of Alpine Linux.

## Contributing

Found an issue or have a suggestion? Open an issue or PR on [GitHub](https://github.com/whadafunk/tftp).

## Author

Created by whadafunk - [https://github.com/whadafunk](https://github.com/whadafunk)
