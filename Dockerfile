FROM ubuntu:16.04

WORKDIR /workdir

RUN apt-get update && apt-get -y upgrade && apt-get autoremove \
    && apt-get install -y --no-install-recommends \
    build-essential \
    software-properties-common \
    cpio \
    lsb-release \
    pciutils \
    curl \
    sudo \
    && sudo add-apt-repository ppa:jonathonf/python-3.6 \
    && apt-get update && apt-get install -y python3.6 python3.6-dev \
    && curl https://bootstrap.pypa.io/get-pip.py | sudo -H python3.6 \
    && pip install numpy

# Replace 1000 with your user / group id
RUN export uid=1000 gid=1000 && \
    mkdir -p /home/developer && \
    echo "developer:x:${uid}:${gid}:Developer,,,:/home/developer:/bin/bash" >> /etc/passwd && \
    echo "developer:x:${uid}:" >> /etc/group && \
    echo "developer ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/developer && \
    chmod 0440 /etc/sudoers.d/developer && \
    chown ${uid}:${gid} -R /home/developer

USER developer
ENV HOME /home/developer

COPY l_openvino_toolkit* /workdir/l_openvino_toolkit
ARG INSTALL_DIR=/opt/intel/computer_vision_sdk
# installing OpenVINO dependencies
RUN cd /workdir/l_openvino_toolkit && \
    ./install_cv_sdk_dependencies.sh

## installing OpenVINO itself
RUN cd /workdir/l_openvino_toolkit && \
    sed -i 's/decline/accept/g' silent.cfg && \
    ./install.sh --silent silent.cfg

RUN echo "source /opt/intel/computer_vision_sdk/bin/setupvars.sh" >> ~/.bashrc

CMD ["/bin/bash"]
