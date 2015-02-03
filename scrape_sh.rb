require 'feedjira'
feed_parsed = Feedjira::Feed.fetch_and_parse("https://news.yahoo.com/rss/topstories", {:ssl_verify_peer => false})
puts feed_parsed