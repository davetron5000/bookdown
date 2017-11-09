
require "spec_helper"
require "bookdown/directives/shbg"
require_relative "../support/matchers/have_command"
require_relative "../support/matchers/recognize"
require_relative "../support/matchers/be_single_line_directive"

RSpec.describe Bookdown::Directives::ShBG do

  specify { expect(described_class.new("ls",[])).to be_single_line_directive }

  describe "::recognize" do
    it "can parse a command with no options" do
      expect(described_class).to recognize("!SHBG ls -ltr", as: {
        command: "ls -ltr",
        options: []
      })
    end
    it "can parse a command with options" do
      expect(described_class).to recognize("!SHBG{foo,bar} ls -ltr", as: {
        command: "ls -ltr",
        options: ["foo","bar"]
      })
    end
    it "ignores other directives" do
      expect(described_class).not_to recognize("!BLAH")
    end
  end
  describe "#execute" do
    context "no pause" do
      subject(:directive) { described_class.new("ls",[ ]) }
      it "executes the command" do
        expect(directive.execute).to have_command(
          Bookdown::Directives::Commands::ShBG,
          command: "ls"
        )
      end
    end
    context "with a pause" do
      subject(:directive) { described_class.new("ls",[ "pause=3" ]) }
      it "executes the command" do
        queue = directive.execute
        expect(queue).to have_command(
          Bookdown::Directives::Commands::ShBG,
          command: "ls"
        )
        expect(queue).to have_command(
          Bookdown::Directives::Commands::Pause,
          seconds: 3
        )
      end
    end
  end
end
