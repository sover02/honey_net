#!/bin/sh

output_file_name=$INPUT_THREATLIST_OUTPUT_S3_FILE_NAME
output_s3_file_name=$INPUT_THREATLIST_OUTPUT_S3_FILE_NAME
output_s3_bucket_name=$INPUT_THREATLIST_OUTPUT_S3_BUCKET_NAME

if [ "$INPUT_DEV_MODE" != "true" ]; then
    export query_lte=$INPUT_THREATLIST_QUERY_LTE
    export query_gte=$INPUT_THREATLIST_QUERY_GTE
fi

if [ "$INPUT_DEV_MODE" = "true" ]; then
    APP_PATH="."
else
    APP_PATH=/app
fi

if [ "$INPUT_DEV_MODE" != "true" ]; then
    # Set up SSH Keys
    mkdir ~/.ssh
    echo "$INPUT_SSH_PRIVATE_KEY" > ~/.ssh/honeypot_ec2-user.pem
    chmod 400 ~/.ssh/honeypot_ec2-user.pem
    echo "$INPUT_SSH_PUBLIC_KEY" > ~/.ssh/honeypot_ec2-user.pub
    chmod 400 ~/.ssh/honeypot_ec2-user.pub

    # Set up AWS CLI
    mkdir ~/.aws
    echo "[default]" > ~/.aws/credentials
    echo "aws_access_key_id = $INPUT_AWS_ACCESS_KEY_ID" >> ~/.aws/credentials
    echo "aws_secret_access_key = $INPUT_AWS_SECRET_ACCESS_KEY" >> ~/.aws/credentials
fi

if [ "$INPUT_ACTION" = "cycle_honeypots" ]; then
    # Run ansible playbook
    cd "$APP_PATH/ansible"
    ansible-playbook main.yml
    echo "honeypots cycled"
elif [ "$INPUT_ACTION" = "update_threatlists" ]; then
    # Update threatlists
    cd "$APP_PATH/update_threatlists" && \
    python3 query_honey_data.py | \
        # Magic code modified from: https://unix.stackexchange.com/a/453349
        # Modified to remove primary_key "title" field
        # Outputs to "/tmp/$INPUT_THREATLIST_OUTPUT_S3_FILE_NAME"
        jq -r '. | to_entries as $row | ((map(keys_unsorted) | add | unique ) as $cols | ([$cols] | flatten), ($row | .[] as $onerow | $onerow | ($cols | map ($onerow.value[.] as $v | if $v == null then "" else $v end) | flatten))) | @csv' > "/tmp/$output_s3_file_name"
    
    # Upload to s3
    aws s3 cp "/tmp/$output_s3_file_name" "s3://$output_s3_bucket_name"

    echo "threatlist uploaded to: s3://$output_s3_bucket_name/$output_s3_file_name"
else
    echo "no ACTION specified"
fi
