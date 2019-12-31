FROM alpine:3.7

WORKDIR /app

# Community repo required for jq
RUN echo http://dl-cdn.alpinelinux.org/alpine/edge/community >> /etc/apk/repositories && \
    apk update && \
    apk add python3 jq

COPY requirements.txt .

# Install python libraries from requirements.txt
RUN pip3 install --upgrade setuptools pip wheel && pip3 install -r requirements.txt

# Copy application
COPY . .

ENTRYPOINT ["/app/entrypoint.sh"]
