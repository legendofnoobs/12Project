# Use an official Ubuntu as a base image
FROM ubuntu:22.04

# Set environment variables to avoid interactive prompts
ENV DEBIAN_FRONTEND=noninteractive

# Install necessary dependencies
RUN apt-get update && apt-get install -y \
    bash \
    zenity \
    procps \
    smartmontools \
    wget \
    && rm -rf /var/lib/apt/lists/*

# Add NVIDIA repository and install NVIDIA drivers (including nvidia-smi)
RUN wget https://developer.download.nvidia.com/compute/cuda/repos/ubuntu2204/x86_64/cuda-keyring_1.0-1_all.deb && \
    dpkg -i cuda-keyring_1.0-1_all.deb && \
    apt-get update && apt-get install -y \
    nvidia-utils-525 \
    && rm -rf /var/lib/apt/lists/*

# Set the working directory inside the container
WORKDIR /usr/local/bin

# Copy the Bash script into the container
COPY dynamic_monitor.sh /usr/local/bin/dynamic_monitor.sh

# Give execute permissions to the script
RUN chmod +x /usr/local/bin/dynamic_monitor.sh

# Set the default command to run the script
CMD ["bash", "/usr/local/bin/dynamic_monitor.sh"]


# to run the file write in the terminal

# install vcxsrv, open launch.exe, set display number to 0, start no clent, check disable access control then run

# export DISPLAY=:0.0

# run xhost + in wsl 

# docker run -it --rm \
#     --env DISPLAY=$DISPLAY \
#     --volume /tmp/.X11-unix:/tmp/.X11-unix \
#     task-manager-clone