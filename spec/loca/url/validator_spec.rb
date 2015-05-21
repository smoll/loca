describe Loca::URL::Validator do
  subject { described_class.new(url) }

  describe "#validate" do
    context "good url" do
      let(:url) { "https://github.com/smoll/loca/pull/1337/commits" }
      it "does not raise an error" do
        expect { subject.validate }.not_to raise_error
      end
    end

    context "bad url" do
      let(:url) { "bad-url.com" }
      it "raises an error" do
        expect { subject.validate }.to raise_error
      end
    end

    context "invalid pull number" do
      let(:url) { "https://github.com/smoll/loca/pull/xyz/commits" }
      it "raises an error" do
        expect { subject.validate }.to raise_error
      end
    end
  end
end
