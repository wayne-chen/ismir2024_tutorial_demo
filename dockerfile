FROM nvcr.io/nvidia/pytorch:23.07-py3

# Update GPG key of NVIDIA Docker Images 
# (See https://developer.nvidia.com/blog/updating-the-cuda-linux-gpg-repository-key/ for more detail)
RUN rm -f /etc/apt/sources.list.d/cuda.list \
 && apt-get update && apt-get install -y --no-install-recommends \
    wget \
 && wget https://developer.download.nvidia.com/compute/cuda/repos/ubuntu1804/x86_64/cuda-keyring_1.0-1_all.deb \
 && dpkg -i cuda-keyring_1.0-1_all.deb \
 && rm -f cuda-keyring_1.0-1_all.deb
RUN apt-get clean && \
    apt-get -y update && \
    apt-get install -y --no-install-recommends nano tmux curl git zip unzip ca-certificates sudo bzip2 libx11-6 build-essential vim gcc g++ make openssl ffmpeg libssl-dev libbz2-dev libreadline-dev libsqlite3-dev python3-tk tk-dev python-tk libfreetype6-dev libffi-dev openmpi-bin openmpi-doc libopenmpi-dev liblzma-dev libncurses-dev libsndfile1 \
    # add basic apt packages
    && apt-get clean \ 
    && rm -rf /var/lib/apt/lists/*


RUN apt update && apt install -y --no-install-recommends apt-transport-https gnupg && \
    curl -fsSL https://bazel.build/bazel-release.pub.gpg | gpg --dearmor >bazel-archive-keyring.gpg && \
    mv bazel-archive-keyring.gpg /usr/share/keyrings && \
    echo "deb [arch=amd64 signed-by=/usr/share/keyrings/bazel-archive-keyring.gpg] https://storage.googleapis.com/bazel-apt stable jdk1.8" > /etc/apt/sources.list.d/bazel.list && \
    apt update && apt install -y --no-install-recommends bazel && \
    apt install -y --no-install-recommends bazel-5.3.2 \
    && apt-get clean \ 
    && rm -rf /var/lib/apt/lists/*

RUN apt-get update & \
    python -m pip install --upgrade pip
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt
RUN pip uninstall -y transformer-engine
RUN pip uninstall -y apex
