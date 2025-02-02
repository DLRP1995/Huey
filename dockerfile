# Use Debian Bookworm as the base image (supports Python 3.11 natively)
FROM debian:bookworm

# Set environment variables:
# - DEBIAN_FRONTEND suppresses interactive prompts.
# - VIRTUAL_ENV defines where the Python virtual environment will live.
# - PATH ensures the venv's binaries are found first.
ENV DEBIAN_FRONTEND=noninteractive \
    VIRTUAL_ENV=/workspace/venv \
    PATH="/workspace/venv/bin:$PATH"

# Install system dependencies:
# - build-essential: Provides GCC and other build tools (required by PyAudio).
# - libglib2.0-0: Provides the libglib-2.0.so.0 needed by PySide6.
# - portaudio19-dev: (If you require PyAudio support.)
# - Python 3.11 and related packages.
RUN set -eux && \
    apt-get update && \
    apt-get install -y --no-install-recommends \
        build-essential \
        libglib2.0-0 \
        portaudio19-dev \
        python3.11 \
        python3.11-venv \
        python3.11-dev \
        python3-pip && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

# Ensure Python 3.11 is the default
RUN ln -sf /usr/bin/python3.11 /usr/bin/python3 && \
    ln -sf /usr/bin/pip3 /usr/bin/pip

# Set the working directory
WORKDIR /workspace

# Create the virtual environment and upgrade pip
RUN set -eux && \
    python3 -m venv /workspace/venv && \
    /workspace/venv/bin/pip install --upgrade pip

# Auto-activate the virtual environment by appending the source command to .bashrc
RUN echo "source /workspace/venv/bin/activate" >> /root/.bashrc

# (Optional) Install your Python packages.
# You can include packages such as pygpt-net, pyaudio, etc.
RUN /workspace/venv/bin/pip install --no-cache-dir \
    pygpt-net \
    pyaudio \
    aiohttp==3.11.11 \
    anyio==4.8.0 \
    beautifulsoup4==4.12.3 \
    bleach[css]==6.2.0 \
    boto3==1.36.0 \
    build==1.2.2.post1 \
    certifi==2024.12.14 \
    cffi==1.17.1 \
    charset-normalizer==3.4.1 \
    cryptography==44.0.0 \
    dataclasses-json==0.6.7 \
    docker==7.1.0 \
    elasticsearch==8.17.0 \
    fastapi==0.115.6 \
    google-auth==2.37.0 \
    grpcio==1.69.0 \
    httpx==0.27.2 \
    jinja2==3.1.5 \
    jsonschema==4.23.0 \
    kubernetes==31.0.0 \
    langchain==0.2.17 \
    numpy==1.26.4 \
    openai==1.59.7 \
    pandas==2.2.3 \
    pillow==10.4.0 \
    protobuf==5.29.3 \
    pydantic==2.10.5 \
    pyside6==6.6.1 \
    redis==5.2.1 \
    requests==2.32.3 \
    sqlalchemy==2.0.37 \
    starlette==0.41.3 \
    sympy==1.13.3 \
    uvicorn==0.23.2 \
    websockets==11.0.3

# Verify that all dependencies are installed correctly
RUN /workspace/venv/bin/pip check

# Secure file permissions for the workspace
RUN chmod -R u+rwX,g+rX,o+rX /workspace

# Default command: launch an interactive shell (with the venv auto-activated via .bashrc)
CMD ["/bin/bash"]
