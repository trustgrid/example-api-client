require "excon"
require "json"

API_KEY = ENV["TG_CLIENT_ID"]
API_SECRET = ENV["TG_CLIENT_SECRET"]

if API_KEY.to_s == "" || API_SECRET == ""
  puts "Please set TG_CLIENT_ID and TG_CLIENT_SECRET environment variables"
  exit 1
end

API_URL = ENV["TG_API_URL"] || "https://api.trustgrid.io"

HEADERS = {
  "Accept" => "application/json",
  "Content-Type" => "application/json",
  "Authorization" => "trustgrid-token #{API_KEY}:#{API_SECRET}",
}

# Get detailed information for a single node (includes things like
# the node's shadow and config).
def fetch_node_config(id)
  puts Excon.get(API_URL + "/node/#{id}", headers: HEADERS).body
end

# Get all nodes.
def fetch_nodes
  puts Excon.get(API_URL + "/node", headers: HEADERS).body
end

# Fetches the current VPN config, changes the description of the first route to
# be the current time, and updates the config through the API. Most config is
# modifiable by issuing a PUT to /node/:id/config/:nameOfConfig, like vpn
# or snmp, eg.
def update_route(id)
  node = JSON.parse(Excon.get(API_URL + "/node/#{id}", headers: HEADERS, expects: [200]).body)
  config = node["config"]["vpn"]
  config["networks"].first["routes"].first["description"] = Time.now.to_s
  puts Excon.put(API_URL + "/node/#{id}/config/vpn", headers: HEADERS, body: config.to_json, expects: [200]).body
end

if ARGV[0]
  fetch_node_config(ARGV[0])
else
  fetch_nodes
end

# example VPN config from one of our test hosts
#{
#  "networks": [
#    {
#      "name": "test-network",
#      "routes": [
#        {
#          "node": "edge-ros-node",
#          "description": "something",
#          "metric": 33,
#          "networkCidr": "10.10.10.10/24"
#        }
#      ],
#      "interfaces": [
#        {
#          "name": "ens192",
#          "outsideNats": [
#            {
#              "localCidr": "172.16.106.58/32",
#              "networkCidr": "172.16.106.58/32"
#            }
#          ],
#          "insideNats": [
#            {
#              "localCidr": "10.20.10.58/32",
#              "networkCidr": "172.16.105.58/32"
#            }
#          ]
#        }
#      ],
#      "route": "172.16.105.58/24"
#    }
#  ]
#}
