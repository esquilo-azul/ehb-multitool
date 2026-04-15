#!/usr/bin/env ruby
# frozen_string_literal: true

require ENV.fetch('RUBY_TO_REQUIRE')
require 'memoized'

class FsBaseObject
  include ::Memoized

  common_constructor :runner, :path do
    self.path = path.to_pathname
  end
end

class RomFile < FsBaseObject
  compare_by :label

  # @return [String]
  def extension
    path.extname.to_s.gsub(/\A\./, '')
  end

  # @return [String]
  def label
    path.basename_noext.to_s
  end

  # @return [Boolean]
  def selected?
    return true if rom_file?
    return false if excluded_file?

    raise "Extension unmapped: \"#{extension}\""
  end

  protected

  # @return [Boolean]
  def excluded_file?
    runner.excluded_extensions.include?(extension)
  end

  # @return [Boolean]
  def rom_file?
    runner.rom_extensions.include?(extension)
  end
end

class RomsSection < FsBaseObject
  LABEL_TRANSLATIONS = {
    closed: 'Finalizado',
    liked: 'Gostado',
    unliked: 'Não gostado',
    played: 'Jogado',
    selected: 'Selecionado',
    unplayed: 'Não jogado',
    sequences: 'Sequência',
    broken: 'Não funciona'
  }.freeze
  ROOT_BASENAME_PARSER = /\A(\d+)_(.+)\z/.to_parser do |m|
    ::Struct.new(:order, :identifier).new(m[1].to_i, m[2].to_sym)
  end

  # @return [String]
  def label
    LABEL_TRANSLATIONS.fetch(parsed_root_basename.identifier)
  end

  # @return [Hash]
  def to_h
    rom_files.map(&:label)
  end

  protected

  memoize def parsed_root_basename
    ROOT_BASENAME_PARSER.parse!(path.basename.to_s)
  end

  def rom_files
    path.glob('**/*').select(&:file?).map { |e| ::RomFile.new(runner, e) }.select(&:selected?).sort
  end
end

class ListGenerator < FsBaseObject
  # @return [Hash]
  def to_h
    sections.inject({}) { |a, e| a.merge(e.label => e.to_h) }
  end

  protected

  def sections
    path.children.select(&:directory?).sort.map { |e| ::RomsSection.new(runner, e) }
  end
end

class TheRunner
  include ::Memoized

  runner_with :help, :output_item do
    arg_opt '-e', '--excluded-extension', repeat: true
    arg_opt '-r', '--rom-extension', repeat: true
    pos_arg :root_directory
  end

  # @return [Array<String>]
  def excluded_extensions
    parsed.excluded_extension
  end

  # @return [Array<String>]
  def rom_extensions
    parsed.rom_extension
  end

  def run
    run_output
  end

  protected

  def item_hash
    list.to_h
  end

  memoize def list
    ::ListGenerator.new(self, parsed.root_directory)
  end
end

TheRunner.run
