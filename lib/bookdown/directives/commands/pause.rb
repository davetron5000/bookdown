require_relative "base_command"

class Bookdown::Directives::Commands::Pause < Bookdown::Directives::Commands::BaseCommand
  attr_reader :seconds
  def initialize(seconds)
    @seconds = seconds
  end

  def execute(_current_output_io,logger)
    logger.info("Pausing for #{@seconds} seconds")
    sleep @seconds
  end
end
