#!/usr/bin/env ruby
# frozen_string_literal: true

require ENV.fetch('RUBY_TO_REQUIRE')

class TheRunner
  runner_with :help, :output

  def run
    run_output
  end

  def output_content
    "=#{::EhbMultitool::Compras::GoogleSpreadsheetFormulas::ItemStatus.new.root}"
  end
end

TheRunner.run
