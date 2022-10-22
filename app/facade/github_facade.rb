require "./app/services/github_service"
require "./app/poros/github_repo"

class GitHubFacade
  def self.all_repos
    data = GitHubService.get_repos

    data.map do |data|
      GitHubRepo.new(data)
    end
  end
  
  def self.repo_name
    all_repos.map do |data|
      if data.name.include?("little-esty-shop")
        return data.full_name
      end
    end
    nil
  end

  def self.three_upcoming_holidays
    holiday_data = GitHubService.get_us_holidays
    holidays = holiday_data.each do |data|
      data[:name]
    end

    holidays.take(3)
  end
end
