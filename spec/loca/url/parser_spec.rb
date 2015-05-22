describe Loca::URL::Parser do
  subject { described_class.new(url) }
  let(:url) { "https://github.com/smoll/loca/pull/1337/" }

  describe "#to_s" do
    it "returns the URL passed to the constructor" do
      expect(subject.to_s).to eq url
    end
  end

  describe "#parse" do
    subject { described_class.new(url) }

    it "returns the instantiated class" do
      expect(subject.parse).to be_a Loca::URL::Parser
    end

    context "valid" do
      before(:each) { subject.parse }

      context "commits url" do
        let(:url) { "https://github.com/smoll/loca/pull/1337/commits" }

        its(:pull_num) { is_expected.to eq "1337" }
        its(:pull_url) { is_expected.to eq "https://github.com/smoll/loca/pull/1337" }
        its(:remote_url) { is_expected.to eq "https://github.com/smoll/loca.git" }
        its(:remote_name) { is_expected.to eq "loca_r_smoll" }
        its(:branch_name) { is_expected.to eq "PULL_1337" }
      end

      context "files url" do
        let(:url) { "https://github.com/smoll/loca/pull/1337/files" }

        its(:pull_num) { is_expected.to eq "1337" }
        its(:pull_url) { is_expected.to eq "https://github.com/smoll/loca/pull/1337" }
        its(:remote_url) { is_expected.to eq "https://github.com/smoll/loca.git" }
        its(:remote_name) { is_expected.to eq "loca_r_smoll" }
        its(:branch_name) { is_expected.to eq "PULL_1337" }
      end

      context "pull url" do
        let(:url) { "https://github.com/smoll/loca/pull/1337" }

        its(:pull_num) { is_expected.to eq "1337" }
        its(:pull_url) { is_expected.to eq "https://github.com/smoll/loca/pull/1337" }
        its(:remote_url) { is_expected.to eq "https://github.com/smoll/loca.git" }
        its(:remote_name) { is_expected.to eq "loca_r_smoll" }
        its(:branch_name) { is_expected.to eq "PULL_1337" }
      end

      context "pull url with trailing slash" do
        let(:url) { "https://github.com/smoll/loca/pull/1337/" }

        its(:pull_num) { is_expected.to eq "1337" }
        its(:pull_url) { is_expected.to eq "https://github.com/smoll/loca/pull/1337" }
        its(:remote_url) { is_expected.to eq "https://github.com/smoll/loca.git" }
        its(:remote_name) { is_expected.to eq "loca_r_smoll" }
        its(:branch_name) { is_expected.to eq "PULL_1337" }
      end
    end

    context "invalid" do
      context "host" do
        let(:url) { "https://badhub.com/smoll/loca/pull/1337" }

        it "raises an error" do
          expect { subject.parse }.to raise_error
        end
      end

      context "url" do
        let(:url) { "badhub.com" }

        it "raises an error" do
          expect { subject.parse }.to raise_error
        end
      end
    end
  end
end
