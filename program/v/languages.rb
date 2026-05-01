#!/usr/bin/env ruby
# frozen_string_literal: true

require ENV.fetch('RUBY_TO_REQUIRE')

class Labelized < SimpleDelegator
  attr_reader :runner

  def initialize(runner, object)
    @runner = runner
    super(object)
  end

  def to_label
    return to_s unless runner.keep_languages?

    to_s.colorize(runner.keep_languages.include?(language) ? :green : :red)
  end
end

class Track < Labelized
  BLANK_LANGUAGE = 'BLANK'

  attr_reader :file

  def initialize(runner, object, file)
    super(runner, object)
    @file = file
  end

  def delete_ffmpeg_args
    return [] if included?

    ['-map', "-0:#{index}"]
  end

  def extract_ffmpeg_args
    return [] unless included?

    ['-map', "0:#{index}", extract_target]
  end

  def included?
    runner.keep_languages.include?(language)
  end

  def language
    language_with_title.presence || BLANK_LANGUAGE
  end

  def extract_target
    file.basename_sub('.*') { |b| "#{b}.#{language}_#{index}.srt" }
  end
end

class FileRunner
  enable_simple_cache
  enable_speaker
  common_constructor :runner, :file do
    run
  end

  private

  def run
    start_banner
    extract_check || delete_check
  end

  def start_banner
    infov 'File', file
    infov "  * Tracks (#{tracks.count})", tracks.map(&:to_label).join(', ')
    infov "  * Languages (#{languages.count})", languages.map(&:to_label).join(', ')
  end

  def tracks_uncached
    audios_if_selected + subtitles_if_selected
  end

  def audios_if_selected
    return [] unless runner.include_audios?

    container.audios.map { |s| ::Track.new(runner, s, file) }
  end

  def subtitles_if_selected
    return [] unless runner.include_subtitles?

    container.subtitles.map { |s| ::Track.new(runner, s, file) }
  end

  def included_tracks_uncached
    tracks.select(&:included?)
  end

  def container_uncached
    ::EhbrsRubyUtils::Videos::File.from_file(file)
  end

  def track_label(track)
    track.to_s.green
  end

  def languages_uncached
    ::Set.new(tracks.map { |s| ::Language.new(runner, s.language) }).to_a.sort
  end

  def delete_check
    return unless runner.delete?

    infov 'Delete args', ::Shellwords.join(delete_tracks_job_args)
    delete_tracks_job.run
  end

  def delete_tracks_job_uncached
    ::EhbrsRubyUtils::Videos::ConvertJob.new(file, delete_tracks_job_args)
  end

  def delete_tracks_job_args
    %w[-map 0] + tracks.flat_map(&:delete_ffmpeg_args) + %w[-c copy]
  end

  def extract_check
    return false unless runner.extract?

    unless included_tracks.any?
      infom 'No selected tracks'
      return true
    end

    infov 'Extract args', ::Shellwords.join(extract_tracks_job_args)
    extract_tracks_command.system!
    true
  end

  def extract_tracks_job_args
    ['-txt_format', 'text', '-i', file] + tracks.flat_map(&:extract_ffmpeg_args)
  end

  def extract_tracks_command_uncached
    ::EhbrsRubyUtils::Executables.ffmpeg.command(*extract_tracks_job_args)
  end
end

class Language < Labelized
  def to_s
    __getobj__
  end

  def language
    __getobj__
  end
end

class TheRunner
  runner_with :help, :filesystem_traverser do
    desc 'Lê e modifica trilhas com idiomas de um vídeo.'
    bool_opt '-a', '--audios', 'Seleciona áudios.'
    bool_opt '-d', '--delete', 'Remove trilhas selecionadas.'
    bool_opt '-e', '--extract', 'Extrai trilhas selecionadas'
    arg_opt '-k', '--keep', 'Mantém legendas com o idioma especificado.'
    bool_opt '-s', '--subtitles', 'Seleciona legendas.'
  end

  def keep_languages?
    keep_languages.present?
  end

  delegate :delete?, :extract?, to: :parsed

  def run
    infov 'Keep', keep_languages
    all_languages_banner
  end

  def include_audios?
    parsed.audios?
  end

  def include_subtitles?
    parsed.subtitles?
  end

  def traverser_check_file(file)
    @files << ::FileRunner.new(self, file)
  end

  private

  def all_languages_uncached
    ::Set.new(files.flat_map(&:languages)).to_a.sort
  end

  def all_languages_banner
    infov 'Languages', all_languages.count
    all_languages.each do |language|
      infov '  * ', language.to_label
    end
  end

  def files_uncached
    @files = []
    run_filesystem_traverser
    @files
  end

  def keep_languages_uncached
    parsed.keep.to_s.split(',').map(&:strip).compact_blank
  end
end

TheRunner.run
