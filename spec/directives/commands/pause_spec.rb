require "spec_helper"
require "time"
require "logger"

require "bookdown/directives/commands/pause"

RSpec.describe Bookdown::Directives::Commands::Pause do
  describe "#execute" do
    let(:logger) { instance_double(Logger) }
    let(:io)     { double }

    subject(:command) { described_class.new(1) }

    before do
      allow(logger).to receive(:info)
    end

    it "sleeps for the given # of seconds" do
      now = Time.now
      command.execute(io,logger)
      expect(Time.now - now).to be > 1
    end
    it "logs about it" do
      command.execute(io,logger)
      expect(logger).to have_received(:info).with("Pausing for 1 seconds")
    end
  end
end
