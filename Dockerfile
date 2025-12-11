FROM python:3.12-alpine

# Install system dependencies including Chromium and ChromeDriver
# chromium-chromedriver is required for selenium
# git is required for installing git dependencies
RUN apk add --no-cache \
    git \
    chromium \
    chromium-chromedriver

# Install uv from official image
COPY --from=ghcr.io/astral-sh/uv:latest /uv /uvx /bin/

# Set environment variables for Chrome
ENV CHROME_BIN=/usr/bin/chromium-browser \
    CHROME_PATH=/usr/lib/chromium/ \
    CHROMEDRIVER_PATH=/usr/bin/chromedriver \
    PYTHONUNBUFFERED=1

# Create a non-root user
RUN adduser -D -u 1000 mcpuser

# Set working directory
WORKDIR /app

# Switch to non-root user
USER mcpuser

# Copy project files
# We copy only necessary files first to leverage cache
COPY --chown=mcpuser:mcpuser pyproject.toml uv.lock ./

# Install dependencies into a virtual environment
# We use --frozen to ensure we use exactly what's in uv.lock
RUN uv sync --frozen --no-install-project

# Copy the rest of the application
COPY --chown=mcpuser:mcpuser . .

# Install the project itself
RUN uv sync --frozen

# Set entrypoint using uv run which handles the venv activation
ENTRYPOINT ["uv", "run", "-m", "linkedin_mcp_server"]
CMD []
