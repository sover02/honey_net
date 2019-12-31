# honey_net

Github action and docker container to deploy a honeypot network in AWS.

Powers: https://intercept.sh/threatlists/

Data retrieved, formatted, and uploaded by: https://github.com/sover02/honey_net_update_threatlists/actions

## Using the Github Action

Example:

```yml
on:
  schedule:
    # Run at 5am UTC, midnight EST
    - cron:  '0 5 * * *'

jobs:
  cycle_honeypot_servers:
    runs-on: ubuntu-latest
    name: Cycle All Honeypot Servers
    steps:
    
    - name: honey_net
      uses: sover02/honey_net@master
      with:
        SSH_PUBLIC_KEY: ${{ secrets.SSH_PUBLIC_KEY }}
        SSH_PRIVATE_KEY: ${{ secrets.SSH_PRIVATE_KEY }}
        AWS_ACCESS_KEY_ID: ${{ secrets.AWS_ACCESS_KEY_ID }}
        AWS_SECRET_ACCESS_KEY: ${{ secrets.AWS_SECRET_ACCESS_KEY }}
        AWS_DEFAULT_REGION: 'us-east-1'
        ELASTICSEARCH_HOST: ${{ secrets.ELASTICSEARCH_HOST }}
        ELASTICSEARCH_PORT: ${{ secrets.ELASTICSEARCH_PORT }}
        ELASTICSEARCH_SCHEME: ${{ secrets.ELASTICSEARCH_SCHEME }}
        ELASTICSEARCH_USER: ${{ secrets.ELASTICSEARCH_USER }}
        ELASTICSEARCH_PASSWORD: ${{ secrets.ELASTICSEARCH_PASSWORD }}
```

## Running Locally

To start, clone the repo and build the image.

```bash
git clone git@github.com:sover02/honey_net.git
cd honey_net
docker build -t sover02/honey_net_rotate-alpine:1.3 .
```

Run this massive `docker run` command.

```bash
docker run \
    -e "INPUT_AWS_ACCESS_KEY_ID=<aws access key>" \
    -e "INPUT_AWS_SECRET_ACCESS_KEY=<aws secret>" \
    -e "INPUT_AWS_DEFAULT_REGION=<aws default region>" \
    -e "INPUT_ELASTICSEARCH_HOST=<elastic host>" \
    -e "INPUT_ELASTICSEARCH_PORT=<elastic port>" \
    -e "INPUT_ELASTICSEARCH_SCHEME=<elastic scheme (HTTP of HTTPS)>" \ 
    -e "INPUT_ELASTICSEARCH_USER=<elastic user>" \
    -e "INPUT_ELASTICSEARCH_PASSWORD=<elastic password>" \
    sover02/honey_net_rotate-alpine:1.3
```

This will deploy one honeypot server in each region, except us-east-1, which is commented out. To select which locations, comment out or uncomment blocks in ./terraform/honeypot_instances.tf

## Teardown

You can destroy all servers without rebuilding them by passing the "INPUT_TERRAFORM_DESTROY_ONLY" flag to the docker container.

Just add `-e "INPUT_TERRAFORM_DESTROY_ONLY=true"` as one of the variables to the above command.
