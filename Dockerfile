FROM alpine:3.4

ARG SSH_PRIVATE_KEY
ARG SSH_PUBLIC_KEY
ARG AWS_ACCESS_KEY_ID
ARG AWS_SECRET_ACCESS_KEY

WORKDIR /app
ENV TERRAFORM_VERSION=0.12.18

RUN apk update && \
    apk add vim wget unzip ca-certificates gcc openssh-client openssl openssl-dev unzip python3 python3-dev libc-dev libffi-dev

COPY ansible/requirements.txt .
RUN pip3 install -r requirements.txt

RUN wget --quiet https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_amd64.zip && \
    unzip terraform_${TERRAFORM_VERSION}_linux_amd64.zip -d /usr/bin

COPY . .

ENTRYPOINT ["/app/entrypoint.sh"]
