describe Loca::URL::Parser do
  subject { described_class.new(url) }

  describe "#to_s" do
    let(:url) { "https://github.com/smoll/loca/pull/1337/" }
    it "returns the URL passed to the constructor" do
      expect(subject.to_s).to eq url
    end
  end

  describe "#parse" do
    let(:parsed) { subject.parse }

    context "valid commits url" do
      let(:url) { "https://github.com/smoll/loca/pull/1337/commits" }

      it "returns a hash" do
        expect(parsed).to be_a Hash
      end

      it "returns the correct pull num" do
        expect(parsed[:pull][:num].to_s).to eq "1337"
      end

      it "returns the correct pull url" do
        expect(parsed[:pull][:url]).to eq "https://github.com/smoll/loca/pull/1337"
      end

      it "returns the correct remote url" do
        expect(parsed[:remote][:url]).to eq "https://github.com/smoll/loca.git"
      end

      it "returns the expected branch name" do
        expect(parsed[:branch_name]).to eq "PULL_1337"
      end
    end

    context "valid files url" do
      let(:url) { "https://github.com/smoll/loca/pull/1337/files" }

      it "returns the correct remote url" do
        expect(parsed[:remote][:url]).to eq "https://github.com/smoll/loca.git"
      end

      it "returns the expected branch name" do
        expect(parsed[:branch_name]).to eq "PULL_1337"
      end
    end

    context "valid pull url" do
      let(:url) { "https://github.com/smoll/loca/pull/1337" }

      it "returns the correct remote url" do
        expect(parsed[:remote][:url]).to eq "https://github.com/smoll/loca.git"
      end

      it "returns the expected branch name" do
        expect(parsed[:branch_name]).to eq "PULL_1337"
      end
    end

    context "valid pull url with trailing slash" do
      let(:url) { "https://github.com/smoll/loca/pull/1337/" }

      it "returns the correct remote url" do
        expect(parsed[:remote][:url]).to eq "https://github.com/smoll/loca.git"
      end

      it "returns the expected branch name" do
        expect(parsed[:branch_name]).to eq "PULL_1337"
      end
    end

    context "invalid host" do
      let(:url) { "https://badhub.com/smoll/loca/pull/1337" }
      it "raises an error" do
        expect { parsed }.to raise_error
      end
    end

    context "invalid url" do
      let(:url) { "badhub.com" }
      it "raises an error" do
        expect { parsed }.to raise_error
      end
    end
  end
end
