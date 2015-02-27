# All Yahoo Pipes feeds are "pre-filtered" to only include posts with Ruby or Rails in title

namespace :scraper do

  desc "Fetch jobs from indeed"
  task scrape_indeed: :environment do
    require 'open-uri'
    require 'json'

    # Set API token and URL
    publisher = ENV["INDEED_PUBLISHER_ID"]
    polling_url = "http://api.indeed.com/ads/apisearch"

    # Specify request parameters
    params = {
      publisher: publisher,
      format: JSON,
      q: 'title:ruby rails',
      co: 'AU',
      highlight: 0,
      limit: 100,
      v: 2
    }

    # Prepare API request
    uri = URI.parse(polling_url)
    uri.query = URI.encode_www_form(params)

    # Submit request
    result = JSON.parse(open(uri).read)

    # Store results in database
    result["results"].each do |result|

      # Create new Post
      @post = Post.new
      @post.jobtitle = result["jobtitle"]
      @post.company = result["company"]
      @post.city = result["city"]
      @post.state = result["state"]
      @post.location = result["formattedLocation"]
      @post.remote = ""
      @post.date = result["date"]
      @post.summary = result["snippet"]
      @post.url = result["url"]
      @post.jobkey = result["jobkey"]

      # Save Post
      @post.save
    end
  end

  desc "Fetch jobs from Stack Overflow"
  task scrape_stack: :environment do
    require 'feedjira'

    feed = Feedjira::Feed.fetch_and_parse("https://pipes.yahoo.com/pipes/pipe.run?_id=cd8049981ac18873c53649f279bd829e&_render=rss", {:ssl_verify_peer => false})
    entries = feed.entries

    # Store results in database
    entries.each do |entry|

      # Create new Post
      @post = Post.new
      @post.jobtitle = entry.title.sub(/\s\bat\s.+/ , '')
      @post.company = entry.title.slice(/(?<=\bat )(.+?)(?= \([^,()]+, [A-Z]{2})/)
      @post.url = entry.url
      @post.date = entry.published

      @post.flagremote

      # Save Post
      @post.save
    end
  end

  desc "Fetch jobs from We Work Remotely"
  task scrape_wework: :environment do
    require 'feedjira'

    feed = Feedjira::Feed.fetch_and_parse("https://pipes.yahoo.com/pipes/pipe.run?_id=fa508ee62731317ff192eeac01acd11a&_render=rss", {:ssl_verify_peer => false})
    entries = feed.entries

    # Store results in database
    entries.each do |entry|

      # Create new Post
      @post = Post.new
      @post.jobtitle = entry.title.slice(/(?<=\S:\s)((\w+).+)/)
      @post.company = entry.title.slice(/(^[^:]+)/)
      @post.url = entry.url
      @post.date = entry.published

      @post.flagremote

      # Save Post
      @post.save
    end
  end

  desc "Destroy all posts"
  task destroy_all_posts: :environment do
    Post.destroy_all
  end

  desc 'Delete all posts and add from all sources'
  task :update_all do
  Rake::Task["scraper:destroy_all_posts"].invoke
  Rake::Task["scraper:scrape_indeed"].invoke
  Rake::Task["scraper:scrape_stack"].invoke
  Rake::Task["scraper:scrape_wework"].invoke
  end

end
