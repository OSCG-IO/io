FROM rockylinux:8

LABEL maintainer="OSCG-IO team"

SHELL ["/bin/bash", "-c"]

USER root

RUN yum update -y \
    && yum install -y wget curl 
RUN yum install -y python3 python3-devel

WORKDIR /opt
RUN python3 -c "$(curl -fsSL https://oscg-io-download.s3.amazonaws.com/REPO/install.py)"
WORKDIR /opt/oscg
RUN ./io install pg14

EXPOSE 5432

CMD /opt/oscg/io start pg14 -y
