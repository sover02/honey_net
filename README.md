# honey_net

Github action and docker container to deploy a honeypot network in AWS.

Powers: Pulls incremental data to power: https://intercept.sh/threatlists/

Notifications are sent to slack.

## Running Locally

To start, clone the repo and build the image.

```bash
git clone git@github.com:sover02/honey_net.git
cd honey_net
docker build -t sover02/honey_net_rotate-alpine:1.3 .
```

Run this massive `docker run` command.

```
docker run \
    -e "INPUT_AWS_ACCESS_KEY_ID=<aws access key>" \
    -e "INPUT_AWS_SECRET_ACCESS_KEY=<aws secret>" \
    -e "INPUT_AWS_DEFAULT_REGION=<aws default region>" \
    -e "INPUT_ELASTICSEARCH_HOST=<elastic host>" \
    -e "INPUT_ELASTICSEARCH_PORT=<elastic port>" \
    -e "INPUT_ELASTICSEARCH_SCHEME=<elastic scheme (HTTP of HTTPS)>" \ 
    -e "INPUT__ELASTICSEARCH_USER=<elastic user>" \
    -e "INPUT_ELASTICSEARCH_PASSWORD=<elastic password>"
```

This will deploy one honeypot server in each region, except us-east-1, which is commented out. To select which locations, comment out or uncomment blocks in ./terraform/honeypot_instances.tf
