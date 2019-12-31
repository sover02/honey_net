#!/bin/sh

output_file_name=$INPUT_THREATLIST_OUTPUT_S3_FILE_NAME
output_s3_file_name=$INPUT_THREATLIST_OUTPUT_S3_FILE_NAME
output_s3_bucket_name=$INPUT_THREATLIST_OUTPUT_S3_BUCKET_NAME

# Set up AWS CLI
mkdir ~/.aws
echo "[default]" > ~/.aws/credentials
echo "aws_access_key_id = $INPUT_AWS_ACCESS_KEY_ID" >> ~/.aws/credentials
echo "aws_secret_access_key = $INPUT_AWS_SECRET_ACCESS_KEY" >> ~/.aws/credentials
echo "region = $INPUT_AWS_DEFAULT_REGION" >> ~/.aws/credentials

# Update threatlists
python3 /app/query_honey_data.py | \
    # Magic code modified from: https://unix.stackexchange.com/a/453349
    # Modified to remove primary_key "title" field
    # Outputs to "/tmp/$INPUT_THREATLIST_OUTPUT_S3_FILE_NAME"
    jq -r '. | to_entries as $row | ((map(keys_unsorted) | add | unique ) as $cols | ([$cols] | flatten), ($row | .[] as $onerow | $onerow | ($cols | map ($onerow.value[.] as $v | if $v == null then "" else $v end) | flatten))) | @csv' > "/tmp/$output_s3_file_name"

# Upload to s3
aws s3 cp "/tmp/$output_s3_file_name" "s3://$output_s3_bucket_name"

echo "threatlist uploaded to: s3://$output_s3_bucket_name/$output_s3_file_name"
