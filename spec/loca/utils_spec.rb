describe Loca::Utils do
  describe "#non_empty_string?" do
    subject { Loca::Utils.non_empty_string?(param) }

    context "nonempty string passed" do
      let(:param) { "hi" }
      it { is_expected.to eq true }
    end

    context "nonempty text after newline passed" do
      let(:param) { "\nOK" }
      it { is_expected.to eq true }
    end

    context "whitespace string passed" do
      let(:param) { " " }
      it { is_expected.to eq false }
    end

    context "newline string passed" do
      let(:param) { "\n" }
      it { is_expected.to eq false }
    end

    context "integer passed" do
      let(:param) { 1 }
      it { is_expected.to eq false }
    end

    context "float passed" do
      let(:param) { 1.0 }
      it { is_expected.to eq false }
    end

    context "nil passed" do
      let(:param) { nil }
      it { is_expected.to eq false }
    end
  end
end
