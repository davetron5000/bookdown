require_relative "single_line_directive"
require_relative "commands/stopbg"

module Bookdown
  module Directives
    class StopBG
      include SingleLineDirective

      def self.recognize(line)
        if line =~ /^!STOPBG({.*})? (.*)$/
          command,options = if $1.nil?
                              [$2,[]]
                            else
                              [$2,$1.to_s.gsub(/[{}]/,'').split(/,/)]
                            end
          self.new(command,options)
        else
          nil
        end
      end

      attr_reader :command, :options
      def initialize(command,options)
        @command = command
        @options = options
      end

      def execute
        [ Commands::StopBG.new(command: @command, show_output: @options.include?("output=true")) ]
      end
    end
  end
end
