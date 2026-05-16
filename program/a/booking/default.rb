#!/usr/bin/env ruby
# frozen_string_literal: true

require ENV.fetch('RUBY_TO_REQUIRE')

class TheRunner
  runner_with :help do
    pos_arg :url
    pos_arg :basename, optional: true
  end

  def run
    infov 'Output path', output_path
    command.system!
    infov 'Output path', output_path
  end

  def basename
    parsed.basename || default_basename
  end

  def command
    ::Cliutils::Core.command('s/ehbrs-tools', 'booking', 'accommodations', *command_arguments)
  end

  def command_arguments
    ['--format', 'csv', '--output', output_path, url]
  end

  def default_basename
    %w[ss checkin checkout].map { |k| url.query_values.fetch(k).parameterize }.join('_')
  end

  def output_path
    ::Cliutils::Core.content_root.join('booking').join("#{basename}.csv").assert_parent
  end

  private

  def url_uncached
    ::Addressable::URI.parse(parsed.url)
  end
end

TheRunner.run
