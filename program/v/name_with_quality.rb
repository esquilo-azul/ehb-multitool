#!/usr/bin/env ruby
# frozen_string_literal: true

require ENV.fetch('RUBY_TO_REQUIRE')

class NameVideo < EhbrsRubyUtils::Videos::File
  enable_speaker
  enable_memoized

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
    ::File.rename(path, new_path)
  end

  def show
    if name_changed?
      puts [new_name.light_white, '<='.cyan, old_name.white].join(' ')
    else
      puts old_name.white
    end
  end

  def old_name
    ::File.basename(path)
  end

  def new_path
    ::File.join(::File.dirname(path), new_name)
  end

  memoize def new_name
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

  memoize def resolution
    ::EhbMultitool::Videos::Resolution.new(video_track.width, video_track.height)
  end

  memoize def resolution_result
    ::Avm::Result.success_or_error(
      resolution.quality_match.to_s,
      resolution.quality.height >= runner.height_minimum
    )
  end

  memoize def video_track
    streams.find(&:video?)
  end
end

class Runner
  include ::Cliutils::Fs::CheckDirectoryOrFile

  runner_with :help do
    desc 'Mostra a qualidade de vídeos.'
    bool_opt '-c', '--confirm', 'Confirma.'
    bool_opt '-r', '--recursive', 'Recursive.'
    pos_arg :path, repeat: true
  end

  delegate :confirm?, to: :parsed

  private

  def run
    parsed.path.each do |path|
      check_path(path)
    end
  end

  def recursive?
    parsed.recursive?
  end

  def check_file(file)
    ::NameVideo.new(self, file).run
  end
end

Runner.run
