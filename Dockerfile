FROM alpine:3.7

ARG INPUT_SSH_PRIVATE_KEY
ARG INPUT_SSH_PUBLIC_KEY
ARG INPUT_AWS_ACCESS_KEY_ID
ARG INPUT_AWS_SECRET_ACCESS_KEY
ARG INPUT_ACTION
ARG INPUT_THREATLIST_OUTPUT_S3_BUCKET_NAME
ARG INPUT_THREATLIST_OUTPUT_S3_FILE_NAME
ARG INPUT_THREATLIST_QUERY_LTE
ARG INPUT_THREATLIST_QUERY_GTE

WORKDIR /app
ENV TERRAFORM_VERSION=0.12.18

# Community repo required for jq
RUN echo http://dl-cdn.alpinelinux.org/alpine/edge/community >> /etc/apk/repositories && \
    apk update && \
    apk add \
    vim \
    unzip jq wget ca-certificates \ 
    gcc libc-dev libffi-dev \
    openssh-client openssl openssl-dev \
    python3 python3-dev

# Install requirements from requirements.txt
COPY requirements.txt .
RUN pip3 install --upgrade setuptools pip wheel && pip3 install -r requirements.txt

# Install terraform
RUN wget --quiet https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_amd64.zip && \
    unzip terraform_${TERRAFORM_VERSION}_linux_amd64.zip -d /usr/bin

COPY . .

ENTRYPOINT ["/app/entrypoint.sh"]
