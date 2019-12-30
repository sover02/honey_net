import os
import boto3
import pandas as pd
from configobj import ConfigObj
from elasticsearch import Elasticsearch
from elasticsearch_dsl import A, Q, Search, Range

# Config Section - will be overwritten by ENV variables
conf = ConfigObj('query_honey_data.conf')

# Override configuration directives if corresponding environment
# variables are present
for section_k, section_v in conf.items():
  for directive_k, directive_v in conf[section_k].items():
    if directive_k in os.environ:
      conf[section_k][directive_k] = os.environ.get(directive_k)

es_host = conf["elastic"]["es_host"]
es_port = conf["elastic"]["es_port"]
es_scheme = conf["elastic"]["es_scheme"]
es_user = conf["elastic"]["es_user"]
es_password = conf["elastic"]["es_password"]

query_lte = conf["query"]["query_lte"]
query_gte = conf["query"]["query_gte"]

output_temp_path = conf["output"]["output_temp_path"]
output_file_name = conf["output"]["output_file_name"]
output_s3_bucket_name = conf["output"]["output_s3_bucket_name"]
output_s3_file_name = conf["output"]["output_s3_file_name"]

# ElasticSearch Instance info
es_client = Elasticsearch(
  [es_host],
  port=es_port,
  scheme=es_scheme,
  http_auth=(es_user, es_password),
)

# AWS s3 Client
s3_client = boto3.resource('s3')

# Accepts and es_client and two DSL time formats (ex: 'now', 'now-1w')
# Outputs a list of json objects containing threatlist data, one-per-item
# Threatlist data contains `src_ip`, `last_seen`, and `count`.
def query_elastic_honey_data(es_client, query_lte, query_gte):
  s = Search(using=es_client, index="filebeat-*")
  s_range = {"range": { "@timestamp": {"lte": query_lte, "gte": query_gte}}}
  s_query = Q('wildcard', eventid='cowrie.login.*')
  s.query = Q('bool', must=[s_range, s_query])

  src_ip_agg = A('terms', field='src_ip', size=2147483647)
  last_seen_agg = A('max', field='@timestamp')
  s.aggs.bucket('by_src_ip', src_ip_agg).bucket('last_seen', last_seen_agg)

  t = s.execute()

  lines = []
  for hit in t.aggregations.by_src_ip.buckets:
    item = {
            "count": hit["doc_count"],
            "last_seen": hit["last_seen"]["value_as_string"],
            "src_ip": hit["key"],
    }
    lines.append(item)

  return lines

# Accepts json data to be written to file, requires `list_of_dicts_input` as list of 
# dictionaries, as well as output `dir_path` and `output_file_name` as strings.
def write_dict_to_csv_file(list_of_dicts_input, output_dir_path, output_file_name):
  file_location = output_dir_path + "/" + output_file_name
  if list_of_dicts_input:
    df = pd.DataFrame(list_of_dicts_input)
    df.sort_values(by=["last_seen", "count"], ascending=False)
    df.to_csv(file_location, columns=["src_ip", "last_seen", "count"], index=False)
    return file_location
  else:
    return False

# Uploads a file to corresponding s3 bucket. Requires an aws s3 client, file location
# of file to be uploaded, s3 bucket name, and file name for s3 file.
def upload_to_s3_bucket(aws_s3_client, file_location, s3_bucket_name, s3_file_name):
  s3_object = s3_client.Object(s3_bucket_name, s3_file_name)
  s3_object.put(Body=open(file_location, 'rb'), ContentType='text/csv')
  return 

# Pulls query from elasticsearch, writes it to a temp file as csv, and then uploads
# csv file to aws s3
if __name__== "__main__":
  honey_net_data = query_elastic_honey_data(es_client, query_lte, query_gte)
  csv_file = write_dict_to_csv_file(honey_net_data, output_temp_path, output_file_name)
  if csv_file:
    upload_to_s3_bucket(s3_client, csv_file, output_s3_bucket_name, output_s3_file_name)
    print("success")
  else:
    print("none")
