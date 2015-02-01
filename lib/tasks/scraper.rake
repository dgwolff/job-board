namespace :scraper do
  desc "Fetch jobs from indeed"
  task scrape: :environment do
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
      limit: 10,
      v: 2
    }

    # Prepare API request
    uri = URI.parse(polling_url)
    uri.query = URI.encode_www_form(params)

    # Submit request
    result = JSON.parse(open(uri).read)

    # Display results to screen
    # puts result["postings"].second["location"]["locality"]

    # Store results in database
    result["results"].each do |result|

      # Create new Post
      @post = Post.new
      @post.jobtitle = result["jobtitle"]
      @post.company = result["company"]
      @post.city = result["city"]
      @post.state = result["state"]
      @post.formatted_location = result["formattedLocation"]
      @post.date = result["date"]
      @post.snippet = result["snippet"]
      @post.url = result["url"]
      @post.jobkey = result["jobkey"]
      @post.formatted_relative_time = result["formattedRelativeTime"]

      # Save Post
      @post.save
    end

  end

  desc "TODO"
  task destroy_all_posts: :environment do
  end

end
