describe Loca::URL do
  let(:pid) { 1 } # Pull request ID
  let(:url) { "https://github.com/smoll/loca/pull/#{pid}" }
  subject { described_class.new(url) }

  let(:expected_branch_name) { "PULL_#{pid}" }
  let(:expected_pr_num) { pid.to_s }

  describe '#initialize' do
    it 'does not raise an error for a valid URL' do
      expect { Loca::URL.new(url) }.to_not raise_error
    end
    # it 'does not raise an error for a GitHub PR URL with additional segments' do
    #   expect { Loca::URL.new("#{url}/something/something") }.to_not raise_error # TODO: technical improvement
    # end
    it 'raises an error for a non-URL' do
      expect { silence(:stderr) { Loca::URL.new('not a URL') } }.to raise_error
    end
    it 'raises an error for a non-GitHub URL' do
      expect { silence(:stderr) { Loca::URL.new('http://bad-url-here.com') } }.to raise_error
    end
    it 'raises an error for a GitHub non-PR URL' do
      expect { silence(:stderr) { Loca::URL.new('https://github.com/smoll/loca/something/something') } }.to raise_error
    end
    it 'raises an error for a GitHub URL without an integer in the PID location' do
      expect { silence(:stderr) { Loca::URL.new('https://github.com/smoll/loca/pull/NaN') } }.to raise_error
    end
  end

  describe '#to_s' do
    it 'returns the url passed to the constructor' do
      expect(subject.to_s).to eq url
    end
  end

  describe '#extract_branch_name' do # private method
    it 'returns the expected branch name' do
      expect(subject.send(:extract_branch_name)).to eq expected_branch_name
    end
  end

  describe '#extract_pr_num' do # private method
    it 'returns the expected branch name' do
      expect(subject.send(:extract_pr_num)).to eq "#{pid}"
    end
  end
end
