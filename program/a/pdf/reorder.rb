#!/usr/bin/env ruby
# frozen_string_literal: true

require ENV.fetch('RUBY_TO_REQUIRE')

class TheRunner
  enable_jobs_runner
  runner_with :help, :output do
    desc 'Reordena as páginas de um arquivo PDF.'
    pos_arg :input_file
    pos_arg :page, repeat: true
  end

  DEFAULT_OUTPUT_OPTION = DEFAULT_FILE_OPTION
  DEFAULT_FILE_TO_OUTPUT = 'reordered.pdf'

  def run
    ::Cliutils::Pdf::Reorder.new(parsed.input_file, file_to_output, parsed.page).run
    infov 'Output file', file_to_output
  end
end

TheRunner.run
