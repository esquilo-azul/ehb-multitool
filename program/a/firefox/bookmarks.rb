#!/usr/bin/env ruby
# frozen_string_literal: true

require ENV.fetch('RUBY_TO_REQUIRE')

class TheRunner
  SELECT_SEPARATOR = '>'
  SELECT_PATH_SEPARATOR = '/'

  runner_with :help, :input, :output do
    bool_opt '-a', '--asciidoctor', 'Formata em Asciidoctor'
    bool_opt '-C', '--only-containers', 'Não mostra os links'
    arg_opt '-M', '--max-level'
    pos_arg :select_path, repeat: true, optional: true
  end

  def run
    run_output
  end

  # @return [String]
  def output_content
    formatter.format(selected_bookmark)
  end

  # @return [Cliutils::Firefox::Bookmark]
  def root_bookmark
    ::Cliutils::Firefox::Bookmark.from_json_string(input_content)
  end

  # @return [Array<String>]
  def select_path
    parsed.select_path.flat_map do |sp|
      sp.split(SELECT_PATH_SEPARATOR).map(&:strip).compact_blank
    end
  end

  # @return [Cliutils::Firefox::Bookmark]
  def selected_bookmark
    root_bookmark.child_by_path(select_path)
  end

  def formatter
    formatter_class.new.only_containers(parsed.only_containers).max_level(parsed.max_level)
  end

  def formatter_class
    if parsed.asciidoctor?
      ::Cliutils::Firefox::BookmarkFormatters::Asciidoctor
    else
      ::Cliutils::Firefox::BookmarkFormatters::Plain
    end
  end
end

TheRunner.run
