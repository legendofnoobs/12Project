# Use an official Ubuntu as a base image
FROM ubuntu:22.04

# Install necessary dependencies (Zenity, NVIDIA drivers, etc.)
RUN apt-get update && apt-get install -y \
    bash \
    zenity \
    nvidia-smi \
    procps \
    smartmontools \
    && rm -rf /var/lib/apt/lists/*

# Set the working directory inside the container
WORKDIR /usr/local/bin

# Copy the Bash script into the container
COPY monitor.sh /usr/local/bin/monitor.sh

# Give execute permissions to the script
RUN chmod +x /usr/local/bin/monitor.sh

# Set the default command to run the script
CMD ["bash", "/usr/local/bin/monitor.sh"]
