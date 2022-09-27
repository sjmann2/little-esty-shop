require "./app/facade/github_facade"

class ApplicationController < ActionController::Base
  before_action :user_names, :repo_name#, :get_pr

  def welcome
  end
  private

  def error_message(errors)
    errors.full_messages.join(', ')
  end

  def user_names
    @user_names = GitHubFacade.user_names
  end

  def repo_name
    @repo_name = GitHubFacade.repo_name
  end

  # def get_pr
  #   @repo_pr_number = GitHubFacade.pull_requests
  # end
end
