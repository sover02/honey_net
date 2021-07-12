FROM alpine:3.7

WORKDIR /app
ENV TERRAFORM_VERSION=0.12.18

RUN apk update && \
    apk add \
        unzip curl ca-certificates \
        openssh-client \
        python3 \
        gcc python3-dev \
        libressl-dev musl-dev libc-dev libffi-dev cargo

# Install terraform
RUN curl -s https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_amd64.zip > terraform_${TERRAFORM_VERSION}_linux_amd64.zip && \
    unzip terraform_${TERRAFORM_VERSION}_linux_amd64.zip -d /usr/bin

# Update pip
RUN pip3 install --upgrade pip

# Install python libraries from requirements.txt
RUN pip3 install --upgrade setuptools pip wheel && \
    pip3 install \
    ansible \
    boto3

# Copy application
COPY . .

ENTRYPOINT ["/app/entrypoint.sh"]
