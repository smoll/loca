describe Loca::CLI do
  describe 'c' do
    it 'raises an error when an invalid repo is supplied' do
      expect { silence(:stderr) { Loca::CLI.start(%w(c https://github.com/fakez/fakezz/pull/1)) } }.to raise_error
    end
  end

  describe '--version' do
    it 'returns the correct version' do
      expect(capture(:stdout) { Loca::CLI.start(%w(-v)) }.strip).to eq(Loca::VERSION)
    end
  end
end
