require "spec_helper"
require "time"
require "logger"
require "stringio"

require "bookdown/directives/commands/stopbg"

RSpec.describe Bookdown::Directives::Commands::StopBG do
  describe "#execute" do
    let(:logger)      { instance_double(Logger) }
    let(:io)          { StringIO.new }
    let(:show_output) { false }
    let(:shbg)        { Bookdown::Directives::Commands::ShBG.new(command: "echo foo") }

    subject(:command) { described_class.new(command: "echo foo", show_output: show_output) }

    before do
      Bookdown::Directives::Commands::ShBG.reset_running_commands!
      allow(logger).to receive(:info)
    end

    it "raises if the command isn't in ShBG's list" do
      expect {
        command.execute(io,logger)
      }.to raise_error(/echo foo/)
    end
    it "stops the pids it finds" do
      shbg.execute(StringIO.new,logger)
      shbg.execute(StringIO.new,logger)
      now = Time.now
      command.execute(io,logger)
      # i.e. should not take 10 seconds
      expect(Time.now - now).to be < 1
    end
    it "logs the stdout" do
      shbg.execute(StringIO.new,logger)
      shbg.execute(StringIO.new,logger)
      sleep 0.2 # give time for commands to complete
      command.execute(io,logger)
      expect(logger).to have_received(:info).with("echo foo exited and produced output:\nfoo\n").exactly(2)
    end
    context "when asked to show output" do
      let(:show_output) { true }
      it "renders the stdout to the io" do
        shbg.execute(StringIO.new,logger)
        shbg.execute(StringIO.new,logger)
        sleep 0.2 # give time for commands to complete
        command.execute(io,logger)
        expect(io.string).to eq("```\nfoo\n```\n```\nfoo\n```\n")
      end
    end
    context "when not asked to show output" do
      let(:show_output) { false }
      it "does not render anything to the io" do
        shbg.execute(StringIO.new,logger)
        shbg.execute(StringIO.new,logger)
        sleep 0.2 # give time for commands to complete
        command.execute(io,logger)
        expect(io.string).to eq("")
      end
    end
  end
end
