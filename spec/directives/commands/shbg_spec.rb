require "spec_helper"
require "time"
require "logger"
require "stringio"

require "bookdown/directives/commands/shbg"

RSpec.describe Bookdown::Directives::Commands::ShBG do
  describe "#execute" do
    let(:logger) { instance_double(Logger) }
    let(:io)     { StringIO.new }

    subject(:command) { described_class.new(command: "ls -l") }

    before do
      described_class.reset_running_commands!
      allow(logger).to receive(:info)
    end

    it "registers the pid of the process in the class-level list of commands" do
      command.execute(io,logger)
      info = command.class.running_commands["ls -l"]
      expect(info.size).to eq(1)
      expect(info.first[:pid]).not_to be_nil
      expect(info.first[:stdout]).not_to be_nil
    end
    it "puts the output into a tmpfile" do
      command.execute(io,logger)
      sleep 0.5 # allow the command to complete in the BG
      info = command.class.running_commands["ls -l"]
      expect(File.read(info.first[:stdout])).not_to eq("")
    end
    it "outputs the shell command used to invoke the command" do
      command.execute(io,logger)
      expect(io.string).to eq("```shell\n> ls -l\n```\n")
    end
    it "logs the pid" do
      command.execute(io,logger)
      info = command.class.running_commands["ls -l"]
      expect(logger).to have_received(:info).with(/#{info.first[:pid]}/)
    end
  end
end
