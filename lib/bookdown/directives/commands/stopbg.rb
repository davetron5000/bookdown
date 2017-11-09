require "timeout"
require_relative "base_command"
require_relative "shbg"

class Bookdown::Directives::Commands::StopBG < Bookdown::Directives::Commands::BaseCommand
  attr_reader :command, :show_output

  def initialize(command:, show_output: false)
    @command = command
    @show_output = show_output
  end

  def execute(current_output_io,logger)
    commands = Bookdown::Directives::Commands::ShBG.running_commands(@command)

    if commands.nil?
      raise "Asked to stop a command that was not started: #{@command}"
    end

    commands.each do |command|
      pid = command[:pid]
      stdout = command[:stdout]
      begin
        logger.info("Stopping PID #{pid} that is running '#{@command}'")
        Timeout::timeout(2) {
          Process.kill("TERM",pid)
          logger.info("Stopped PID #{pid} that was running '#{@command}'")
        }
      rescue Timeout::Error
        logger.info("PID #{pid} that is running '#{@command}' didn't exit in 2 seconeds.  Killing with -9")
        begin
          Process.kill(9,pid)
          logger.info("Killed PID #{pid} that was running '#{@command}'")
        rescue => ex
          logger.error("While killing PID #{pid} that was running '#{@command}', got #{ex.message}")
        end
      end
      output = File.read(stdout)
      logger.info("#{@command} exited and produced output:\n#{output}")
      if @show_output
        current_output_io.puts "```"
        current_output_io.puts(output)
        current_output_io.puts "```"
      end
    end
  end
end
