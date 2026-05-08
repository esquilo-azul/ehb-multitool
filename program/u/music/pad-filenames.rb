#!/usr/bin/env ruby
# frozen_string_literal: true

require ENV.fetch('RUBY_TO_REQUIRE')

class PadFile < Cliutils::Fs::FileRename
  enable_speaker
  include ::EacRubyUtils::SimpleCache

  def initialize(parent, path)
    super(path)
    self.parent = parent
  end

  def new_basename
    m = /\A\d*([^\d].*)\z/.match(basename)
    if m
      track_number.to_s.rjust(parent.padding_size, '0') + m[1]
    else
      fatal_error("Unknown pattern: \"#{basename}\"")
    end
  end

  def track_number_on_basename_uncached
    m = /\A(\d+)/.match(basename)
    m ? m[1].to_i : nil
  end

  def track_number_uncached
    track_number_on_basename || parent.next_track_number
  end

  private

  attr_accessor :parent
end

class PadDirectory
  enable_speaker
  include ::EacRubyUtils::SimpleCache

  def initialize(dir, options)
    @dir = dir
    @options = options
    run
  end

  def next_track_number
    i = 1
    loop do
      if used_track_numbers.include?(i)
        i += 1
      else
        used_track_numbers.add(i)
        return i
      end
    end
  end

  private

  attr_reader :dir, :options

  def run
    s = dir
    s += ' (Empty)' if files.empty?
    infov('Directory', s.to_s)
    files.each { |f| process_file(f) }
  end

  def files_uncached
    Dir.entries(dir).sort
      .reject { |e| e.start_with?('.') }
      .map { |e| ::PadFile.new(self, ::File.join(dir, e)) }
      .select(&:file?)
  end

  def process_file(file)
    return unless file.rename?

    infov("  * #{file.basename}", file.new_basename)
    file.rename if options[:confirm]
  end

  def used_track_numbers_uncached
    r = Set.new
    files.each do |f|
      r.add(f.track_number_on_basename) if f.track_number_on_basename
    end
    r
  end

  def padding_size_uncached
    r = files.count.to_s.length
    [r, 2].max
  end
end

class Runner < Cliutils::DocoptRunner
  include ::Cliutils::Fs::CheckDirectoryOrFile

  enable_speaker

  DOC = <<~DOCOPT
    Completa com zeros nome de arquivo de música.

    Usage:
      __PROGRAM__ [options] [<path>...]
      __PROGRAM__ -h | --help

    Options:
      -h --help             Show this screen.
      -r --recursive        Recursive
      -c --confirm          Confirma

  DOCOPT

  private

  def run
    root_paths.each do |path|
      warn("\"#{path}\" not exist") unless ::File.exist?(path)
      check_path(path)
    end
  end

  def check_directory(dir)
    PadDirectory.new(dir, confirm: options['--confirm'])
  end

  def root_paths
    r = options['<path>']
    r.any? ? r : %w[.]
  end

  def recursive?
    options['--recursive']
  end
end

Runner.run
