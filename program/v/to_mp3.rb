#!/usr/bin/env ruby
# frozen_string_literal: true

require ENV.fetch('RUBY_TO_REQUIRE')

class TheRunner
  VALID_EXTENSIONS = %w[.flac .mp3 .m4a .mp4 .opus].freeze

  enable_speaker
  include ::Cliutils::Fs::CheckDirectoryOrFile

  runner_with :help, :filesystem_traverser do
    desc 'Converte para MP3.'
    bool_opt '-c', '--confirm', 'Confirma mudanças.'
  end

  def run
    start_banner
    run_filesystem_traverser
  end

  private

  def traverser_check_file(path)
    return unless VALID_EXTENSIONS.include?(::File.extname(path).downcase)

    info path
    return unless parsed.confirm?

    output_basename = path.basename_sub('.*') { |b| "#{b}.mp3" }
    ::Cliutils::Fs::ConvertFiles.new(path, output_basename: output_basename).run do |input, output|
      mp3_convert(input, output)
    end
  end

  def start_banner
    infov 'Paths', paths
    infov 'Recursive?', recursive?
  end

  def paths
    parsed.paths
  end

  def mp3_convert(input, output)
    ::EacRubyUtils::Envs.local.command('ffmpeg', '-i', input, '-vn', '-codec:a', 'libmp3lame',
                                       '-b:a', '320k', '-f', 'mp3', output).system!
  end
end

TheRunner.run
