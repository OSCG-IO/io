FROM debian:stable-slim

LABEL maintainer="OSCG-IO team"

SHELL ["/bin/bash", "-c"]

USER root

RUN addgroup --system oscg \
    && adduser --system oscg --ingroup oscg \
    && apt-get update \
    && apt-get install -y wget curl python3

RUN chown oscg:oscg /opt
RUN touch /root/.pgpass && chown oscg:oscg /root/.pgpass

USER oscg:oscg
WORKDIR /opt
RUN python3 -c "$(curl -fsSL https://oscg-io-download.s3.amazonaws.com/REPO/install.py)"
WORKDIR /opt/oscg
RUN ./io install pg14

EXPOSE 5432

CMD /opt/oscg/io start pg14 -y
