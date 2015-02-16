describe 'Checking out a GitHub PR locally' do
  let(:pr_url) { 'https://github.com/octocat/Spoon-Knife/pull/4865' }
  let(:expected_branch_name) { 'PULL_4865' }

  before(:each) do
    clone_test_repo
    cd_to_cloned_dir
  end

  after(:each) { teardown }

  context "the repo exists as the 'upstream' remote" do
    before(:each)  { set_upstream }

    it 'checks out then deletes' do
      shellout! "loca c #{pr_url}"
      expect(current_branch.strip).to eq expected_branch_name
      shellout! "loca c #{pr_url} -d"
      expect(current_branch.strip).to_not eq expected_branch_name
    end

    it 'checks out then prompts to overwrite' do
      shellout! "loca c #{pr_url}"
      expect(current_branch.strip).to eq expected_branch_name
      shellout! "loca c #{pr_url}", input: 'yes'
      expect(current_branch.strip).to eq expected_branch_name
    end
  end

  context 'the repo does not exist as a remote' do
    it 'fails to checkout' do
      expect { shellout! "loca c #{pr_url}" }.to raise_error
      expect(current_branch.strip).to_not eq expected_branch_name
    end
  end

  context 'the wrong URL is supplied' do
    it 'fails to checkout' do
      expect { shellout! 'loca c https://github.com/octocat/Spoon-Knife/wrong/4865' }.to raise_error
      expect(current_branch.strip).to_not eq expected_branch_name
    end
  end
end
