describe Loca::Git do
  let(:pid) { 1 } # Pull request ID
  let(:url) { "https://github.com/smoll/loca/pull/#{pid}" }
  let(:remote_name) { 'loca-fake-remote' }
  let(:remote_url) { 'https://github.com/smoll/loca.git' }
  subject { described_class.new(url, remote_name) }

  let(:expected_branch_name) { "PULL_#{pid}" }
  let(:branches_without_expected) { ['master'] }
  let(:branches_with_expected) { branches_without_expected << expected_branch_name }

  describe '#git' do # private method that shells out to git
    it 'raises an error when an invalid git command is supplied' do
      expect { capture(:stderr) { subject.send(:git, 'not-a-git-command') } }.to raise_error
    end

    it 'prints to stderr when an invalid git command is supplied, but we do not want to fail on stderr' do
      output = capture(:stderr) { subject.send(:git, 'not-a-git-command', false) }
      expect(output).to include "git: 'not-a-git-command' is not a git command"
    end
  end

  describe '#branches' do # private method
    it 'returns all local branches' do
      cmd = "for-each-ref refs/heads/ --format='%(refname:short)'"
      expect(subject).to receive(:git).with(cmd).and_return 'a_branch'
      expect(subject.send(:branches)).to eq ['a_branch']
    end
  end

  describe '#remote_mapping' do # private method
    it "returns all of the repo's remotes" do
      expect(subject).to receive(:git).with('remote show -n').and_return remote_name
      expect(subject).to receive(:git).with("config --get remote.#{remote_name}.url").and_return remote_url
      expect(subject.send(:remote_mapping)).to eq(remote_name => remote_url)
    end
  end

  describe '#extract_remote_name' do # private method
    it 'returns the local repo remote name corresponding to the Pull Request URL' do
      expect(subject).to receive(:remote_mapping).and_return(remote_name => remote_url) # investigate this

      expect(subject.send(:extract_remote_name)).to eq remote_name
    end
  end

  describe '#current_branch' do # private method
    it 'returns the current branch' do
      expect(subject).to receive(:git).with('rev-parse --abbrev-ref HEAD').once
      subject.send(:current_branch)
    end
  end

  describe '#checkout' do # private method
    it 'checks out the expected branch' do
      expect(subject).to receive(:git).with("checkout #{expected_branch_name}").once
      subject.send(:checkout)
    end
  end

  describe '#checkout_another_branch' do # private method
    it 'checks out a branch that is not the current one' do
      allow(subject).to receive(:branches).and_return %w(branch1 branch2)
      allow(subject).to receive(:current_branch).and_return 'branch1'
      expect(subject).to receive(:git).with('checkout branch2').once
      silence(:stdout) { subject.send(:checkout_another_branch) }
    end

    it 'raises an error when there is no other branch to check out' do
      allow(subject).to receive(:branches).and_return ['branch1']
      allow(subject).to receive(:current_branch).and_return 'branch1'

      expect { silence(:stderr) { subject.send(:checkout_another_branch) } }.to raise_error
    end
  end

  describe '#fetch' do
    before do
      allow(subject).to receive(:git) # ensure we don't actually shell out to `git`
    end

    it 'deletes before fetching when the branch already exists' do
      allow(subject).to receive(:branches).and_return branches_with_expected
      expect(subject).to receive(:delete).once

      subject.fetch
    end

    it 'fetches the remote pull request' do
      allow(subject).to receive(:branches).and_return branches_without_expected

      # Investigate why this git command prints to $stderr, i.e. we must pass false as the 2nd arg:
      expect(subject).to receive(:git).with("fetch #{remote_name} pull/#{pid}/head:#{expected_branch_name}", false)

      subject.fetch
    end
  end

  describe '#delete' do # should attempt to delete a branch with name 'PULL_1'
    it 'raises an error when the branch does not exist' do
      allow(subject).to receive(:branches).and_return branches_without_expected
      expect { silence(:stderr) { subject.delete } }.to raise_error
    end

    it 'deletes the branch when it exists' do
      allow(subject).to receive(:branches).and_return branches_with_expected
      allow(subject).to receive(:current_branch).and_return('master')
      expect(subject).to receive(:git).with("branch -D #{expected_branch_name}").once

      subject.delete
    end

    it 'checks out another branch if attempting to delete current branch' do
      allow(subject).to receive(:branches).and_return branches_with_expected
      allow(subject).to receive(:current_branch).and_return expected_branch_name

      expect(subject).to receive(:checkout_another_branch).once
      expect(subject).to receive(:git).with("branch -D #{expected_branch_name}").once

      subject.delete
    end
  end

  describe '#first_time_creating?' do
    it 'returns false when the branch already exists' do
      allow(subject).to receive(:branches).and_return branches_with_expected
      expect(subject.first_time_creating?).to eq false
    end

    it 'returns true when the branch does not exist' do
      allow(subject).to receive(:branches).and_return branches_without_expected
      expect(subject.first_time_creating?).to eq true
    end
  end

  describe '#git_match_http?' do
    it 'returns true when matching urls are supplied' do
      git_url = 'https://github.com/smoll/loca.git'
      expect(subject.git_match_http?(git_url, url))
    end

    it 'returns true when different URI schemes but matching urls are supplied' do
      git_url = 'git://github.com/smoll/loca.git'
      expect(subject.git_match_http?(git_url, url))
    end

    it 'returns false when non-matching urls are supplied' do
      git_url = 'git://github.com/someoneelse/loca.git'
      expect(subject.git_match_http?(git_url, url))
    end
  end
end
