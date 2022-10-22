require "rails_helper"
require "./app/service/github_service"


RSpec.describe(GitHubService) do
  it "can get a uri" do
    allow(GitHubService).to receive(:get_uri).and_return([{name: 'Columbus Day'}, {name: 'Veterans Day'}, {name: 'Thanksgiving Day'}])
    
    holidays = GitHubService.get_uri("https://date.nager.at/api/v3/NextPublicHolidays/us")
    
    expect(holidays).to(be_an(Array))
    expect(holidays[0]).to(be_a(Hash))
    expect(holidays[0]).to(have_key(:name))
  end

  it 'can get a uri with a authorization token' do
    allow(GitHubService).to receive(:get_uri_token).and_return([{name: "little-esty-shop", full_name: "sjmann2/little-esty-shop"}])

    repos = GitHubService.get_uri("https://api.github.com/users/sjmann2/repos")

    expect(repos).to(be_an(Array))
    expect(repos[0]).to(be_a(Hash))
    expect(repos[0]).to(have_key(:name))
  end

  it "can get all repositories" do
    allow(GitHubService).to receive(:get_repos).and_return([{name: "little-esty-shop", full_name: "sjmann2/little-esty-shop"}])

    repos = GitHubService.get_repos

    expect(repos).to(be_an(Array))
    expect(repos[0]).to(be_a(Hash))
    expect(repos[0]).to(have_key(:name))
  end

  it 'can get user data' do
    allow(GitHubService).to receive(:get_user_names).and_return([{:login=>"noahvanekdom"}])

    names = GitHubService.get_user_names

    expect(names).to(be_an(Array))
    expect(names[0]).to(be_a(Hash))
    expect(names[0]).to(have_key(:login))
  end

  it 'can get a list of us holidays' do
    allow(GitHubService).to receive(:get_us_holidays).and_return([{name: 'Columbus Day'}, {name: 'Veterans Day'}, {name: 'Thanksgiving Day'}])
    
    holidays = GitHubService.get_us_holidays

    expect(holidays).to(be_an(Array))
    expect(holidays[0]).to(be_a(Hash))
    expect(holidays[0]).to(have_key(:name))
  end
end
