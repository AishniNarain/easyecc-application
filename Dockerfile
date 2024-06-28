# # Use an appropriate base image with Python and necessary tools
# FROM fedora:latest

# # Update package list and install necessary dependencies
# RUN dnf -y update && dnf -y install \
#     cryptopp-devel \
#     python3 \
#     python3-devel \
#     gcc \
#     gcc-c++ \
#     make \
#     python3-pip \
#     python3-setuptools

# # Set the working directory
# WORKDIR /app

# # Copy your application files into the container
# COPY . .

# # Install the Python module using below commands
# RUN pip install .

# # Set the entry point or default command
# CMD ["python3", "easyecc.py"]


# Use Python10 as the base image
FROM python:3.10-slim

# Install Python and pip
RUN apt-get update && \
    apt-get install -y python3-pip libpq-dev && \
    rm -rf /var/lib/apt/lists/*

# Set the working directory in the container
WORKDIR /app

# Copy the current directory contents into the container
COPY . .

# Copy Supervisor configuration file (optional, create on host)
# COPY supervisord.conf .
# COPY supervisord.conf /etc/supervisor/supervisord.conf
# COPY conf.d /etc/supervisor/conf.d


# Install any needed dependencies specified in requirements.txt
# RUN pip3 install -r requirements.txt

# Installing cryptopp
WORKDIR /cryptopp
RUN make
RUN make test
RUN make install

# custom module install use for encryption/decryption
WORKDIR /easyecc
RUN pip3 install .

# WORKDIR /aphttps://github.com/AishniNarain/easyecc-app.gitp

ENTRYPOINT ["/usr/bin/supervisord", "-c", "/app/supervisord.conf"]
CMD ["-n"]

