require "./app/facade/github_facade"

class ApplicationController < ActionController::Base
  before_action :repo_name

  def welcome
  end
  private

  def error_message(errors)
    errors.full_messages.join(', ')
  end

  def repo_name
    @repo_name = GitHubFacade.repo_name
  end
end
