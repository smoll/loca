describe Loca::Git::BranchCreator do
  subject { described_class.new("1337", "PULL_1337", "loca_r_smoll", "https://github.com/smoll/loca") }

  # This is probably better off being functionally tested
  # Otherwise, we end up stubbing out specific `git` commands which is very brittle
  # See https://sethvargo.com/unit-and-functional-testing-git-with-rspec/

  describe "#add_remote" do
    it "uses and avoids duplicating a preexisting remote" do
      expect(subject).to receive(:git).with("remote show -n").and_return "origin\n"
      expect(subject).to receive(:git)
        .with("config --get remote.origin.url")
        .and_return "https://github.com/smoll/loca\n"

      subject.send :add_remote
    end
  end
end
