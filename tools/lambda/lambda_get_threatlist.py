from __future__ import print_function

import csv
import json
import time
import polling
import datetime
import boto3

print('Loading function')

def lambda_handler(event, context):
    #print("Received event: " + json.dumps(event, indent=2))
    print("value1 = " + event['key1'])
    print("value2 = " + event['key2'])
    print("value3 = " + event['key3'])
    #return event['key1']  # Echo back the first key value
    #raise Exception('Something went wrong')

    epoch_now = int(time.time())
    epoch_24_hours_ago = epoch_now-(60*60*24)
    
    client = boto3.client('logs', region_name='us-east-1')
    s3_client = boto3.resource('s3')
    
    s3_bucket = 'honey-net-threat-list'
    output_file = 'threatlist_24hr.csv'
    
    response = client.start_query(
        logGroupName='honey_net-logs',
        startTime=epoch_24_hours_ago,
        endTime=epoch_now,
        queryString='fields timestamp, sensor, src_ip, eventid, session \
                     | filter eventid ~= /cowrie.login.*/ \
                     | stats count(*) as count, max(@timestamp) as last_seen by src_ip',
        # limit=
    )
    
    query_id = response['queryId']
    
    
    # while check for status = Running
    polling.poll(
        lambda: (client.get_query_results(queryId=query_id)['status'] != 'Running'),
        step=4,
        timeout=300,
    )
    
    
    results = client.get_query_results(queryId=query_id)
    results_log_data = results['results']
    
    
    threat_list = [ ]
    for line in results_log_data:
        new_line = { }
        for pair in line:
           new_line[pair['field']] = pair['value']
        threat_list.append(new_line)
        
    for idx, line in enumerate(threat_list):
        last_seen = int(line['last_seen']) / 1000.0
        last_seen = datetime.datetime.fromtimestamp(last_seen).strftime('%Y-%m-%d %H:%M:%S UTC')
        threat_list[idx]['last_seen'] = last_seen
    
    with open('/tmp/threatlist_24hours.csv', 'wb') as output_file:
        dict_writer = csv.DictWriter(output_file, threat_list[0].keys())
        dict_writer.writeheader()
        dict_writer.writerows(threat_list)
    
    bucket = s3_client.Bucket(s3_bucket)
    s3_client.Object(s3_bucket, output_file).put(Body=open('/tmp/'+output_file, 'rb'))
    
    
    #print(json.dumps(threat_list))
    return
