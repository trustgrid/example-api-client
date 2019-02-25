
require 'excon'

API_KEY=ENV['TG_CLIENT_ID']
API_SECRET=ENV['TG_CLIENT_SECRET']

if API_KEY.to_s == '' || API_SECRET == ''
  puts "Please set TG_CLIENT_ID and TG_CLIENT_SECRET environment variables"
  exit 1
end

API_URL = 'https://api.trustgrid.io'

HEADERS = {
  'Accept' => 'application/json',
  'Authorization' => "trustgrid-token #{API_KEY}:#{API_SECRET}",
}

def fetch_node_config(id)
  puts Excon.get(API_URL + "/node/#{id}", headers: HEADERS).body
end

def fetch_nodes
  puts Excon.get(API_URL + "/node", headers: HEADERS).body
end

if ARGV[0]
  fetch_node_config(ARGV[0])
else
  fetch_nodes
end

