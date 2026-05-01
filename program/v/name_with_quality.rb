#!/usr/bin/env ruby
# frozen_string_literal: true

require ENV.fetch('RUBY_TO_REQUIRE')

class NameVideo < Cliutils::Videos::File
  enable_speaker
  enable_simple_cache

  attr_reader :runner

  def initialize(runner, file)
    super(file)
    @runner = runner
  end

  def run
    show
    rename if runner.confirm?
  end

  private

  def rename
    return unless name_changed?

    warn("\"#{new_path}\" already exist") if ::File.exist?(new_path)
    ::File.rename(file, new_path)
  end

  def show
    if name_changed?
      puts [new_name.light_white, '<='.cyan, old_name.white].join(' ')
    else
      puts old_name.white
    end
  end

  def old_name
    ::File.basename(file)
  end

  def new_path
    ::File.join(::File.dirname(file), new_name)
  end

  def new_name_uncached
    ext = ::File.extname(old_name)
    name = ::File.basename(old_name, ext)
    return old_name if / - \S+\z/.match(name)

    "#{name} - #{quality.to_s.gsub('..', '-')}#{ext}"
  end

  def name_changed?
    old_name != new_name
  end

  def quality
    resolution.quality_match
  end

  def resolution_uncached
    resolution_candidates.each do |r|
      return r if r.valid?
    end
    raise "Resolution not found in \"#{video_track.extra}\", #{resolution_candidates}"
  end

  def resolution_candidates
    video_track.extra.scan(/(\d+)x(\d+)/).map do |m|
      ::Cliutils::Videos::Resolution.new(m[0].to_i, m[1].to_i)
    end
  end

  def resolution_result_uncached
    ::Avm::Result.success_or_error(
      resolution.quality_match.to_s,
      resolution.quality.height >= runner.height_minimum
    )
  end

  def video_track_uncached
    tracks.find { |t| t.type == 'Video' }
  end
end

class Runner < Cliutils::DocoptRunner
  enable_speaker
  enable_simple_cache
  include ::Cliutils::Fs::CheckDirectoryOrFile

  DOC = <<~DOCOPT
    Mostra a qualidade de vídeos.

    Usage:
      __PROGRAM__ [options] <path>...
      __PROGRAM__ -h | --help

    Options:
      -h --help         Show this screen.
      -r --recursive    Recursive.
      -c --confirm      Confirma.
  DOCOPT

  def confirm?
    options.fetch('--confirm')
  end

  private

  def run
    options['<path>'].each do |path|
      check_path(path)
    end
  end

  def recursive?
    options['--recursive']
  end

  def check_file(file)
    ::NameVideo.new(self, file).run
  end
end

Runner.run
