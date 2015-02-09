describe Loca::CLI do
  let(:invalid_url) { 'https://github.com/fakez/fakezz/pull/1' }
  let(:url) { 'https://github.com/smoll/loca/pull/1' }
  subject { described_class.new }

  before do # ensure we don't shell out to git
    allow_any_instance_of(Loca::Git).to receive(:fetch)
    allow_any_instance_of(Loca::Git).to receive(:checkout)
  end

  describe 'c' do
    it 'fetches and checks out the branch locally' do
      expect_any_instance_of(Loca::Git).to receive(:branch_name).and_return 'PULL_1'
      expect_any_instance_of(Loca::Git).to receive(:first_time_creating?).and_return true

      output = capture(:stdout) { described_class.start(%W(c #{url})) }.strip
      expect(output).to end_with 'Checked out PULL_1!'
    end

    it 'fetches and overwrites existing branch if the user says yes to overwrite' do
      expect_any_instance_of(Loca::Git).to receive(:branch_name).and_return 'PULL_1'
      expect_any_instance_of(Loca::Git).to receive(:first_time_creating?).and_return false
      silence(:stdout) { allow_any_instance_of(described_class).to receive(:yes?).and_return true }

      output = capture(:stdout) { described_class.start(%W(c #{url})) }.strip
      expect(output).to end_with 'Checked out PULL_1!'
    end

    it 'raises an error when the branch exists and the user says no to overwrite' do
      expect_any_instance_of(Loca::Git).to receive(:branch_name).and_return 'PULL_1'
      expect_any_instance_of(Loca::Git).to receive(:first_time_creating?).and_return false
      silence(:stdout) { allow_any_instance_of(described_class).to receive(:yes?).and_return false }

      expect { silence(:stderr) { described_class.start(%W(c #{url})) } }.to raise_error
    end

    it 'raises an error when an invalid repo is supplied' do
      expect { silence(:stderr) { described_class.start(%W(c #{invalid_url})) } }.to raise_error
    end

    it 'deletes when the delete flag is appended' do
      expect_any_instance_of(Loca::Git).to receive(:branch_name).and_return 'PULL_1'
      expect_any_instance_of(Loca::Git).to receive(:delete)

      output = capture(:stdout) { described_class.start(%W(c #{url} -d)) }.strip
      expect(output).to eq 'Deleted PULL_1!'
    end
  end

  describe 'd' do
    it 'deletes' do
      expect_any_instance_of(Loca::Git).to receive(:branch_name).and_return 'PULL_1'
      expect_any_instance_of(Loca::Git).to receive(:delete)

      output = capture(:stdout) { described_class.start(%W(d #{url})) }.strip
      expect(output).to eq 'Deleted PULL_1!'
    end

    it 'raises an error when an invalid repo is supplied' do
      expect { silence(:stderr) { described_class.start(%W(d #{invalid_url})) } }.to raise_error
    end
  end

  describe '--version' do
    it 'returns the correct version' do
      expect(capture(:stdout) { described_class.start(%w(-v)) }.strip).to eq(Loca::VERSION)
    end
  end

  describe '#yes?' do
    it "returns true when user types 'yes'" do
      allow(subject.instance_variable_get(:@shell)).to receive(:gets).and_return 'yes'

      expect(subject.send(:yes?, 'Is this the real life?')).to eq true
    end

    it "returns false when user types 'no'" do
      allow(subject.instance_variable_get(:@shell)).to receive(:gets).and_return 'no'

      expect(subject.send(:yes?, 'Is this just fantasy?')).to eq false
    end
  end
end
