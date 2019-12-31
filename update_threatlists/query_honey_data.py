import os
import json
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

es_host = os.environ['INPUT_THREATLIST_ELASTICSEARCH_HOST']
es_port = os.environ['INPUT_THREATLIST_ELASTICSEARCH_PORT']
es_scheme = os.environ['INPUT_THREATLIST_ELASTICSEARCH_SCHEME']
es_user = os.environ['INPUT_THREATLIST_ELASTICSEARCH_USER']
es_password = os.environ['INPUT_THREATLIST_ELASTICSEARCH_PASSWORD']

query_lte = os.environ['INPUT_THREATLIST_QUERY_LTE']
query_gte = os.environ['INPUT_THREATLIST_QUERY_GTE']

# ElasticSearch Instance info

es_client = Elasticsearch(
  [es_host],
  port=es_port,
  scheme=es_scheme,
  http_auth=(es_user, es_password),
)

# Accepts and es_client and two DSL time formats (ex: 'now', 'now-1w')
# Outputs a list of json objects containing threatlist data, one-per-item
# Threatlist data contains `src_ip`, `last_seen`, and `count`.
def query_elastic_honey_data(es_client, query_lte, query_gte):
  s = Search(using=es_client, index="cowrie")
  s_range = {"range": { "@timestamp": {"lte": query_lte, "gte": query_gte}}}
  s_query = Q('wildcard', eventid='cowrie.login.*')
  s.query = Q('bool', must=[s_range, s_query])

  src_ip_agg = A('terms', field='src_ip.keyword', size=2147483647)
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

if __name__== "__main__":
  honey_net_data = query_elastic_honey_data(es_client, query_lte, query_gte)
  print(json.dumps(honey_net_data))
