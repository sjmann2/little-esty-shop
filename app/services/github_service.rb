require "httparty"
require "json"

class GitHubService
  def self.get_repos
    return [{name: "little-esty-shop", full_name: "sjmann2/little-esty-shop"}] if Rails.env == "test"
    get_uri_token("https://api.github.com/users/sjmann2/repos", headers: {"Authorization" => "Bearer " + ENV["TOKEN"]})
  end

  def self.get_us_holidays
    return [{name: 'Columbus Day'}, {name: 'Veterans Day'}, {name: 'Thanksgiving Day'}] if Rails.env == "test"
    get_uri("https://date.nager.at/api/v3/NextPublicHolidays/us")
  end

  def self.get_uri_token(uri, header)
    response = HTTParty.get(uri, header)
    JSON.parse(response.body, symbolize_names: true)
  end

  def self.get_uri(uri)
    response = HTTParty.get(uri)
    JSON.parse(response.body, symbolize_names: true)
  end
end
