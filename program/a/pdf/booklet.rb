#!/usr/bin/env ruby
# frozen_string_literal: true

require ENV.fetch('RUBY_TO_REQUIRE')

class TheRunner
  runner_with :help, :output do
    desc 'converte PDF para livreto.'
    pos_arg :input_file
  end

  DEFAULT_OUTPUT_OPTION = DEFAULT_FILE_OPTION
  DEFAULT_FILE_TO_OUTPUT = 'booklet.pdf'

  def run
    start_banner
    perform
  end

  private

  # @return [Pathname]
  def input_file
    parsed.input_file.to_pathname
  end

  def perform
    command.system!
  end

  def start_banner
    infov 'Output file', output_file
  end

  # @return [Pathname]
  def output_file
    (parsed.output || DEFAULT_FILE_TO_OUTPUT).to_pathname
  end

  def command
    ::EacRubyUtils::Envs.local.command('pdfbook2', input_file, '--paper=a4paper')
  end
end

TheRunner.run
