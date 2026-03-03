# IaC - Dockerfile with insecure configurations

# Using outdated base image with known vulnerabilities (CKV_DOCKER_2)
FROM ubuntu:18.04

# Running as root (CKV_DOCKER_8)
USER root

# Hardcoded secrets in ENV (CKV_DOCKER_5)
ENV DB_PASSWORD="docker_hardcoded_pass"
ENV AWS_ACCESS_KEY_ID="AKIAIOSFODNN7DKEXAMPLE"
ENV AWS_SECRET_ACCESS_KEY="wJalrXUtnFEMI/K7MDENG/bPxRfiCYDKEXAMPLE"
ENV API_KEY="docker_hardcoded_api_key_1234"
ENV JWT_SECRET="docker_jwt_secret_never_rotate"

# Installing unnecessary packages, no version pinning (CKV_DOCKER_7)
RUN apt-get update && apt-get install -y \
    curl \
    wget \
    netcat \
    nmap \
    python2 \
    telnet \
    ftp \
    sudo

# Secrets in build args (exposed in image history)
ARG SECRET_KEY=hardcoded_build_secret
ARG DB_PASS=hardcoded_db_pass

# Copying everything including sensitive files (CKV_DOCKER_9)
COPY . /app

# No HEALTHCHECK defined (CKV_DOCKER_28)
WORKDIR /app

# Running pip as root, no --no-cache-dir
RUN pip install -r requirements.txt

# Exposing unnecessary ports
EXPOSE 22
EXPOSE 3306
EXPOSE 5432
EXPOSE 6379
EXPOSE 27017
EXPOSE 8080

# Using shell form (allows variable expansion / injection) (CKV_DOCKER_25)
CMD python app.py
