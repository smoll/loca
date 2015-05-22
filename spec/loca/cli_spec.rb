describe Loca::CLI do
  let(:cli) { described_class.new(argv, stdin, stdout, stderr) }
  let(:stdin) { StringIO.new } # from http://stackoverflow.com/a/16507814/3456726
  let(:stdout) { StringIO.new }
  let(:stderr) { StringIO.new }

  describe "#execute!" do
    context "-v" do
      let(:argv) { ["-v"] }

      it "returns the version" do
        expect do
          cli.execute!
          expect(stdout.string).to eq Loca::VERSION
        end.to raise_error(SystemExit) # because execute! calls `exit 0` (or 1, etc.)
        # from http://stackoverflow.com/a/28047771/3456726
      end

      it "exits cleanly" do
        expect { cli.execute! }.to terminate.with_code 0
      end
    end

    context "-h" do
      let(:argv) { ["-h"] }

      it "returns the version" do
        expect do
          cli.execute!
          expect(stdout.string).to include "Usage: loca <url> [options]"
        end.to raise_error(SystemExit)
      end

      it "exits cleanly" do
        expect { cli.execute! }.to terminate.with_code 0
      end
    end

    context "invalid option" do
      let(:argv) { ["--invalid-option"] }

      it "exits 1" do
        expect { cli.execute! }.to terminate.with_code 1
      end
    end
  end
end
