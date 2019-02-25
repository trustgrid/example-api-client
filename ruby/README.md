
To use the ruby client:

1. Set `TG_CLIENT_ID` and `G_CLIENT_SECRET` to your Trustgrid credentials.
1. Run `bundle install`
1. Run `ruby example.rb` with no arguments to get a list of nodes. You can pipe it to `jq` for easier consumption. Run `ruby example.rb <nodeid>` to fetch more detailed information about a given node.


