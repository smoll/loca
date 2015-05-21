require "aruba/cucumber"

Before "@integration" do
  @aruba_timeout_seconds = 10
  @aruba_io_wait_seconds = 2
  @dirs = [Dir.tmpdir, "aruba"]
  FileUtils.rm_rf(current_dir)
end

# Still trying to figure this out...
# Ref: https://github.com/cucumber/aruba/blob/master/features/support/custom_main.rb#L21
Before "@in-process" do
  Aruba::InProcess.main_class = Loca::CLI
  Aruba.process = Aruba::InProcess
end

After "~@in-process" do
  Aruba.process = Aruba::SpawnProcess
end
