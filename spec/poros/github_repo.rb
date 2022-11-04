require './app/poros/github_repo'

RSpec.describe GitHubRepo do
  describe 'attributes' do
    it 'has a name and full name' do
      data = {name: 'little-esty-shop',
              full_name: 'noahvanekdom/little-esty-shop'}

      github_repo = GitHubRepo.new(data)

      expect(github_repo).to be_instance_of(GitHubRepo)
      expect(github_repo.name).to eq('little-esty-shop')
      expect(github_repo.full_name).to eq('noahvanekdom/little-esty-shop')
    end
  end
end