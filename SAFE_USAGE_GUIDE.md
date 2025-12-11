# Safe Usage Guide

## Secure Configuration

To securely configure and run the LinkedIn MCP Server, follow these guidelines.

### 1. Environment Isolation (Docker)

Run the server in a Docker container to isolate it from the host system. This mitigates risks related to clipboard access and file system access.

**Recommended Docker Run Command:**

```bash
docker run -d \
  --name linkedin-mcp \
  --read-only \
  --tmpfs /tmp \
  -e LINKEDIN_EMAIL="your-email@example.com" \
  -e LINKEDIN_PASSWORD="your-password" \
  -e LINKEDIN_COOKIE="your-li-at-cookie" \
  -e LOG_LEVEL="INFO" \
  linkedin-mcp-server
```

**Key Flags:**
*   `--read-only`: Mounts the container's root filesystem as read-only.
*   `--tmpfs /tmp`: Mounts a writable temporary filesystem for temporary files (needed by Chrome).
*   `-e LOG_LEVEL="INFO"`: Ensure debug logging is disabled to prevent accidental leakage (though code patches have been applied).

### 2. Secret Management

*   **NEVER** hardcode credentials in source code or Dockerfiles.
*   Use environment variables (`LINKEDIN_EMAIL`, `LINKEDIN_PASSWORD`, `LINKEDIN_COOKIE`) passed at runtime.
*   For local usage, rely on the system keyring integration provided by the application (`keyring` package).

### 3. Network Restrictions

Restrict outbound network access for the container if possible. The server needs access to:
*   `www.linkedin.com` (HTTPS)
*   GitHub/PyPI (only during build)

Block all other outbound traffic to prevent data exfiltration.

### 4. Updates

Regularly rebuild the Docker image to pull the latest security updates for the base image (Python) and Chrome/ChromeDriver.

## Interactive Mode Warning

The interactive setup mode (`--interactive` or default CLI usage) uses `pyperclip` to access your clipboard. Be aware of this behavior and ensure you trust the local environment when running in this mode.
