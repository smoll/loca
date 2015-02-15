describe 'Check out a GitHub PR locally' do
  context "when the repo exists as the 'upstream' remote" do
    before(:all) do
      clone_test_repo
      cd_to_cloned_dir
      set_upstream
    end

    after(:all) { teardown }

    it 'checks out a PR' do
      shellout! 'loca c https://github.com/octocat/Spoon-Knife/pull/4865'
      expect(shellout!('git rev-parse --abbrev-ref HEAD').strip).to eq 'PULL_4865'
    end
  end
end
