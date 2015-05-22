describe Loca::Git::Common do
  let(:dummy_class) { Class.new { include Loca::Git::Common } }
  subject { dummy_class.new }

  describe "#git" do
    context "nonexistent command" do
      let(:command) { "fakegitcmd" }

      it "raises an error" do
        expect { subject.git(command) }.to raise_error
      end
    end
  end

  describe "#git_urls_match?" do
    # These should all equate with one another:
    let(:remote_url) { "https://github.com/smoll/loca" }
    let(:remote_url_with_git) { "https://github.com/smoll/loca.git" }
    let(:remote_url_with_slash) { "https://github.com/smoll/loca/" }

    it "matches when both have trailing '.git'" do
      result = subject.git_urls_match?(remote_url_with_git, remote_url_with_git)
      expect(result).to eq true
    end

    it "matches when both lack trailing '.git'" do
      result = subject.git_urls_match?(remote_url, remote_url)
      expect(result).to eq true
    end

    it "matches when only one has trailing '.git'" do
      result = subject.git_urls_match?(remote_url_with_git, remote_url)
      expect(result).to eq true
    end

    it "matches when one has a trailing slash" do
      result = subject.git_urls_match?(remote_url_with_git, remote_url_with_slash)
      expect(result).to eq true
    end

    it "returns false when they do not match" do
      result = subject.git_urls_match?(remote_url, "https://github.com/smoll/locaz")
      expect(result).to eq false
    end
  end
end
