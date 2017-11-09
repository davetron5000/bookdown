
require "spec_helper"
require "bookdown/directives/stopbg"
require_relative "../support/matchers/have_command"
require_relative "../support/matchers/recognize"
require_relative "../support/matchers/be_single_line_directive"

RSpec.describe Bookdown::Directives::StopBG do

  specify { expect(described_class.new("ls",[])).to be_single_line_directive }

  describe "::recognize" do
    it "can parse a command with no options" do
      expect(described_class).to recognize("!STOPBG ls -ltr", as: {
        command: "ls -ltr",
        options: []
      })
    end
    it "can parse a command with options" do
      expect(described_class).to recognize("!STOPBG{foo,bar} ls -ltr", as: {
        command: "ls -ltr",
        options: ["foo","bar"]
      })
    end
    it "ignores other directives" do
      expect(described_class).not_to recognize("!BLAH")
    end
  end
  describe "#execute" do
    context "no output" do
      subject(:directive) { described_class.new("ls",[ ]) }
      it "executes the command" do
        expect(directive.execute).to have_command(
          Bookdown::Directives::Commands::StopBG,
          command: "ls",
          show_output: false
        )
      end
    end
    context "with output" do
      subject(:directive) { described_class.new("ls",[ "output=true" ]) }
      it "executes the command" do
        queue = directive.execute
        expect(queue).to have_command(
          Bookdown::Directives::Commands::StopBG,
          command: "ls",
          show_output: true
        )
      end
    end
  end
end
