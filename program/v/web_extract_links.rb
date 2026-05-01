#!/usr/bin/env ruby
# frozen_string_literal: true

require ENV.fetch('RUBY_TO_REQUIRE')

class SourceAddress
  enable_simple_cache
  VIDEO_SOURCE_PARSER = /video_url:\s*'([^']+)'/.to_parser do |m|
    m[1].strip
  end

  common_constructor :runner, :uri

  def video_sources
    [video_source]
  end

  def video_source
    VIDEO_SOURCE_PARSER.parse(aranha_parser.content)
  end

  private

  def aranha_parser_uncached
    ::Aranha::Parsers::Html::Base.new(uri)
  end
end

class TheRunner
  LIST_COLUMNS = %i[uri video_source].freeze
  ROW_STRUCT = ::Struct.new(*LIST_COLUMNS)

  runner_with :help, :output_list, :input do
    pos_arg :uri, repeat: true, optional: true
  end

  # @return [void]
  def run
    infov 'URIs', uris.count
    run_output
  end

  # @return [Enumerable<Symbol>]
  def list_columns
    LIST_COLUMNS
  end

  # @return [Enumerable<Struct>]
  def list_rows
    source_addresses.flat_map do |source_address|
      infov 'Searching', source_address.uri
      source_address.video_sources.map do |video_source|
        ROW_STRUCT.new(source_address.uri, video_source)
      end
    end
  end

  private

  # @return [Enumerable<Addressable::URI>]
  def uris_uncached
    (input_content.each_line + parsed.uri).map(&:strip).compact_blank.uniq.sort.map(&:to_uri)
  end

  # @return [Enumerable<SourceAddress>]
  def source_addresses
    uris.map { |uri| SourceAddress.new(self, uri) }
  end
end

TheRunner.run
