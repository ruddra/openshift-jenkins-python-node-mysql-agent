FROM openshift/jenkins-slave-base-centos7

LABEL maintainer="me@ruddra.com"

# Install miniconda
USER root
RUN yum install -y bzip2 gcc python-devel mysql-devel sqlite

ENV NPM_CONFIG_PREFIX=$HOME/.npm-global \
    PATH=$HOME/node_modules/.bin/:$HOME/.npm-global/bin/:$PATH

ARG NODE_VERSION=10.15.3
ARG YARN_VERSION=1.13.0


RUN curl -fsSL https://rpm.nodesource.com/setup_10.x | bash - && \
    curl -fsSL https://dl.yarnpkg.com/rpm/yarn.repo | tee /etc/yum.repos.d/yarn.repo && \
    INSTALL_PKGS="nodejs-${NODE_VERSION} gcc-c++ make yarn-${YARN_VERSION}" && \
    yum install -y --setopt=tsflags=nodocs $INSTALL_PKGS && \
    # rpm -V $INSTALL_PKGS && \
    yum clean all -y && \
    rm -rf /var/cache/yum/*

RUN echo 'export PATH=/opt/conda/bin:$PATH' > /etc/profile.d/conda.sh && \
    wget --quiet https://repo.continuum.io/miniconda/Miniconda3-4.3.31-Linux-x86_64.sh -O ~/miniconda.sh && \
    /bin/bash ~/miniconda.sh -b -p /opt/conda && \
    rm ~/miniconda.sh && \
    /opt/conda/bin/conda clean -tipsy && \
    npm install 

RUN npm install -g less

RUN chmod -R 777 /opt/conda

ENV PATH /opt/conda/bin:$PATH

USER 1001