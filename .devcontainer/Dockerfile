FROM ubuntu:22.04

ARG USERNAME=vscode
ARG USER_UID=1000
ARG USER_GID=1000

ENV DEBIAN_FRONTEND=noninteractive
ENV DISPLAY=:1
ENV LANG=en_US.UTF-8
ENV LC_ALL=en_US.UTF-8

RUN groupadd --gid ${USER_GID} ${USERNAME} \
 && useradd -m -s /bin/bash \
      --uid ${USER_UID} --gid ${USER_GID} ${USERNAME} \
 && apt-get update \
 && apt-get install -y --no-install-recommends sudo \
 && echo "${USERNAME} ALL=(ALL) NOPASSWD:ALL" \
      > /etc/sudoers.d/${USERNAME} \
 && chmod 0440 /etc/sudoers.d/${USERNAME}

RUN apt-get update \
 && apt-get install -y --no-install-recommends \
    ca-certificates curl wget git git-lfs unzip \
    make python3 python3-pip python3-numpy \
    tcl tcl-dev tcllib tk \
    build-essential flex bison gawk perl time bc \
    libreadline8 libtcl8.6 libtk8.6 zlib1g \
    libstdc++6 libgcc-s1 libyaml-cpp0.7 \
    xvfb xfce4 xfce4-terminal thunar dbus-x11 \
    x11vnc novnc websockify supervisor \
    magic ngspice gtkwave verilator iverilog \
    locales vim \
 && locale-gen en_US.UTF-8 \
 && rm -rf /var/lib/apt/lists/*

RUN set -eux; \
    curl -L \
      https://www.klayout.org/downloads/Ubuntu-22/klayout_0.30.7-1_amd64.deb \
      -o /tmp/klayout.deb; \
    apt-get update; \
    apt-get install -y --no-install-recommends /tmp/klayout.deb; \
    rm -rf /var/lib/apt/lists/* /tmp/klayout.deb

RUN set -eux; \
    test -n "${TOOLCHAIN_URL}"; \
    test -n "${TOOLCHAIN_SHA256}"; \
    curl -L "${TOOLCHAIN_URL}" -o /tmp/toolchain.tar.gz; \
    echo "${TOOLCHAIN_SHA256}  /tmp/toolchain.tar.gz" \
      | sha256sum -c -; \
    mkdir -p /opt/orfs-tools; \
    tar -xzf /tmp/toolchain.tar.gz -C /opt/orfs-tools; \
    rm /tmp/toolchain.tar.gz; \
    ln -s /opt/orfs-tools/OpenROAD/bin/openroad /usr/local/bin/openroad; \
    ln -s /opt/orfs-tools/yosys/bin/yosys /usr/local/bin/yosys

ENV PATH="/opt/orfs-tools/OpenROAD/bin:/opt/orfs-tools/yosys/bin:${PATH}"
ENV LD_LIBRARY_PATH="/opt/orfs-tools/OpenROAD/lib:/opt/orfs-tools/yosys/lib"

RUN openroad -version && yosys -V && klayout -v

COPY .devcontainer/supervisord.conf \
     /etc/supervisor/conf.d/vnc.conf

EXPOSE 6080

CMD ["/usr/bin/supervisord", "-n"]
