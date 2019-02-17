import csv
import json
import time
import polling
import datetime
import boto3


client = boto3.client('logs', region_name='us-east-1')

response = client.start_query(
    logGroupName='honey_net-logs',
    startTime=1550124120,
    endTime=1550127092,
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

with open('/tmp/threatlist.csv', 'wb') as output_file:
    dict_writer = csv.DictWriter(output_file, threat_list[0].keys())
    dict_writer.writeheader()
    dict_writer.writerows(threat_list)

print(json.dumps(threat_list))