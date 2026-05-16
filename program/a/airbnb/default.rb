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
    ::Cliutils::Core.command('s/ehbrs-tools', 'airbnb', 'accommodations', *command_arguments)
  end

  def command_arguments
    ['--format', 'csv', '--output', output_path, url]
  end

  def default_basename
    %w[localization start_date end_date].map { |k| send(k).parameterize }.join('_')
  end

  def output_path
    ::Cliutils::Core.content_root.join('airbnb').join("#{basename}.csv").assert_parent
  end

  protected

  # @return [String]
  def end_date
    url.query_values.fetch('checkout')
  end

  # @return [String]
  def localization
    ::CGI.unescape(url.path.split('/').reject(&:blank?).fetch(1))
  end

  # @return [String]
  def start_date
    url.query_values.fetch('checkin')
  end

  # @return [Addressable::URI]
  memoize def url
    ::Addressable::URI.parse(parsed.url)
  end
end

TheRunner.run
