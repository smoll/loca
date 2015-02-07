describe Loca::Git do
  let(:pid) { 1 } # Pull request ID
  let(:url) { "https://github.com/smoll/loca/pull/#{pid}" }
  let(:remote_name) { 'loca-fake-remote' }
  subject { described_class.new(url, remote_name) }

  let(:expected_branch_name) { "PULL_#{pid}" }
  let(:branches_without_expected) { ['master'] }
  let(:branches_with_expected) { branches_without_expected << expected_branch_name }

  before do
    allow(subject).to receive(:git) # ensure we don't actually shell out to `git`
  end

  describe '#fetch' do
    it 'deletes before fetching when the branch already exists' do
      allow(subject).to receive(:branches).and_return branches_with_expected
      expect(subject).to receive(:delete).once

      subject.fetch
    end

    it 'fetches the remote pull request' do
      allow(subject).to receive(:branches).and_return branches_without_expected

      # Investigate why we need to ignore stderr here, i.e. pass false as the 2nd arg:
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
end
