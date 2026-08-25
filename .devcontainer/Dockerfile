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
    ca-certificates curl wget git git-lfs unzip file \
    make python3 python3-pip python3-numpy \
    tcl tcl-dev tcllib tcl-tclreadline tk \
    build-essential flex bison gawk perl time bc \
    libreadline8 libtcl8.6 libtk8.6 zlib1g \
    libstdc++6 libgcc-s1 libyaml-cpp0.7 \
    libqt5charts5 \
    xvfb xfce4 xfce4-terminal thunar dbus-x11 \
    x11vnc novnc websockify supervisor \
    magic ngspice gtkwave verilator iverilog \
    locales vim \
 && locale-gen en_US.UTF-8 \
 && rm -rf /var/lib/apt/lists/*

# KLayout 0.30.7 amd64
RUN set -eux; \
    curl -fL \
      https://www.klayout.org/downloads/Ubuntu-22/klayout_0.30.7-1_amd64.deb \
      -o /tmp/klayout.deb; \
    apt-get update; \
    apt-get install -y --no-install-recommends /tmp/klayout.deb; \
    rm -rf /var/lib/apt/lists/* /tmp/klayout.deb

# Yosys x86-64 from OSS CAD Suite
RUN set -eux; \
    curl -fL \
      https://github.com/YosysHQ/oss-cad-suite-build/releases/download/2025-10-31/oss-cad-suite-linux-x64-20251031.tgz \
      -o /tmp/oss-cad.tgz; \
    mkdir -p /opt; \
    tar -xzf /tmp/oss-cad.tgz -C /opt; \
    ln -s /opt/oss-cad-suite /opt/oss-cad; \
    rm /tmp/oss-cad.tgz

ENV PATH="/opt/oss-cad-suite/bin:/usr/local/bin:${PATH}"
ENV YOSYS_EXE="/opt/oss-cad-suite/bin/yosys"
ENV YOSYS_PLUGIN_PATH="/opt/oss-cad-suite/share/yosys/plugins"

# Proven x86-64 OpenROAD package
COPY .devcontainer/install-openroad.sh /tmp/install-openroad.sh

RUN chmod +x /tmp/install-openroad.sh \
 && /tmp/install-openroad.sh \
 && rm /tmp/install-openroad.sh

ENV OPENROAD_EXE="/usr/local/bin/openroad"

# Fail immediately if architecture, dependencies or tools are wrong
RUN uname -m \
 && file /usr/local/bin/openroad \
 && file /opt/oss-cad-suite/bin/yosys \
 && ldd /usr/local/bin/openroad \
 && openroad -version \
 && yosys -V \
 && klayout -v

COPY .devcontainer/supervisord.conf \
     /etc/supervisor/conf.d/vnc.conf

EXPOSE 6080

CMD ["/usr/bin/supervisord", "-n"]
