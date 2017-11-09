require "tempfile"
require_relative "base_command"

class Bookdown::Directives::Commands::ShBG < Bookdown::Directives::Commands::BaseCommand
  attr_reader :command

  def self.reset_running_commands!
    @running_commands = {}
  end

  def self.running_commands(command=nil)
    if command.nil?
      @running_commands ||= {}
    else
      @running_commands.delete(command)
    end
  end

  def initialize(command:)
    @command = command
  end

  def execute(current_output_io,logger)
    stdout = Tempfile.new("shbg")
    pid = spawn(@command, 1 => stdout)

    logger.info("Spawned '#{@command}' with PID #{pid}")

    self.class.running_commands[@command] ||= []
    self.class.running_commands[@command] << { pid: pid, stdout: stdout }

    current_output_io.puts "```shell"
    current_output_io.puts "> #{@command}"
    current_output_io.puts "```"
  end
end
