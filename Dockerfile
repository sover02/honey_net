FROM alpine:3.7

WORKDIR /app
ENV TERRAFORM_VERSION=0.12.18

# Community repo required for jq
RUN echo http://dl-cdn.alpinelinux.org/alpine/edge/community >> /etc/apk/repositories && \
    apk update && \
    apk add \
    unzip jq wget ca-certificates \ 
    gcc libc-dev libffi-dev \
    openssh-client openssl openssl-dev \
    python3 python3-dev

# Copy application
COPY . .

# Install terraform
RUN wget --quiet https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_amd64.zip && \
    unzip terraform_${TERRAFORM_VERSION}_linux_amd64.zip -d /usr/bin

# Install python libraries from requirements.txt
RUN pip3 install --upgrade setuptools pip wheel && pip3 install -r requirements.txt

ENTRYPOINT ["/app/entrypoint.sh"]
