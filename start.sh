#!/bin/bash
# Exit early on errors
set -eu
# Python buffers stdout. Without this, you won't see what you "print" in the Activity Logs
export PYTHONUNBUFFERED=true

# Install Python 3.10 if not already installed
command -v python3.10 >/dev/null 2>&1 || {
  echo "Installing Python 3.10..."
  # This would depend on your OS, but for Ubuntu/Debian it might be:
  # sudo apt-get update && sudo apt-get install -y python3.10 python3.10-venv
}

# Create Python 3.10 virtual environment
VIRTUALENV=./venv
if [ ! -d $VIRTUALENV ]; then
  python3.10 -m venv $VIRTUALENV
fi

# Install specific pip version into virtual environment
if [ ! -f $VIRTUALENV/bin/pip ] || [ "$($VIRTUALENV/bin/pip --version | grep -o 'pip 24.3.1')" != "pip 24.3.1" ]; then
  curl --silent --show-error --retry 5 https://bootstrap.pypa.io/get-pip.py | $VIRTUALENV/bin/python
  $VIRTUALENV/bin/pip install pip==24.3.1
fi

# Install the requirements
$VIRTUALENV/bin/pip install -r requirements.txt

# Run your glorious application
$VIRTUALENV/bin/python server.py