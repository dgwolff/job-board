json.array!(@posts) do |post|
  json.extract! post, :id, :jobtitle, :company, :city, :state, :formatted_location, :date, :snippet, :url, :jobkey
  json.url post_url(post, format: :json)
end
