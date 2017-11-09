require_relative "single_line_directive"
require_relative "commands/shbg"
require_relative "commands/pause"

module Bookdown
  module Directives
    class ShBG
      include SingleLineDirective

      def self.recognize(line)
        if line =~ /^!SHBG({.*})? (.*)$/
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
        queue = [ Commands::ShBG.new(command: @command) ]
        options.each do |option|
          if option =~ /pause=(\d+)$/
            queue << Commands::Pause.new($1.to_i)
          end
        end
        queue
      end
    end
  end
end
