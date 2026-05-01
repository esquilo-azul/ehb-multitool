#!/usr/bin/env ruby
# frozen_string_literal: true

require ENV.fetch('RUBY_TO_REQUIRE')

class VideoQuality < Cliutils::Videos::File
  enable_speaker
  enable_simple_cache

  attr_reader :runner

  def initialize(runner, file)
    super(file)
    @runner = runner
  end

  def video?
    video_track.present?
  end

  def show_video_quality
    return unless video?

    infov file, quality_info
  end

  def output_file
    out("#{file}\n") if output_file?
  end

  private

  def output_file?
    (ok? && runner.output_ok?) || (!ok? && runner.output_not_ok?)
  end

  def ok?
    frame_rate_result.success? && resolution_result.success?
  end

  def video_track_uncached
    tracks.find { |t| t.type == 'Video' }
  end

  def quality_info
    [resolution_result.label, frame_rate_result.label, resolution.resolution_to_s,
     resolution.ratio].join(' | ')
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

  def frame_rate_uncached
    m = /(\d+(?:.\d+)?) fps/.match(video_track.extra)
    return m[1].to_f if m

    raise "Frame rate not found in \"#{video_track.extra}\""
  end

  def frame_rate_result_uncached
    ::Avm::Result.success_or_error("#{frame_rate} FPS", frame_rate >= runner.frame_rate_minimum)
  end

  def resolution_result_uncached
    ::Avm::Result.success_or_error(
      resolution.quality_match.to_s,
      resolution.quality.height >= runner.height_minimum
    )
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
      -h --help                             Show this screen.
      -r --recursive                        Recursive.
      -f --frame-rate-min=<float-value>     Minimum frame rate to check [default: 23.0].
      -H --height-min=<int-value>           Minimum height [default: 720].
      -o                                    Output files.
      -y                                    Output only ok files.
      -n                                    Output only not ok files.
  DOCOPT

  def frame_rate_minimum
    options.fetch('--frame-rate-min').to_f
  end

  def height_minimum
    options.fetch('--height-min').to_f
  end

  def output?
    options.fetch('-o')
  end

  def output_ok?
    options.fetch('-y') || !options.fetch('-n')
  end

  def output_not_ok?
    options.fetch('-n') || !options.fetch('-y')
  end

  private

  def run
    start_banner
    show_videos
    output_videos
  end

  def start_banner
    infov 'Minimum frame rate', frame_rate_minimum
    infov 'Minimum height', height_minimum
    infov 'Output?', output?
    infov 'Output ok?', output_ok?
    infov 'Output not ok?', output_not_ok?
  end

  def show_videos
    videos.each(&:show_video_quality)
  end

  def output_videos
    return unless output?

    videos.each(&:output_file)
  end

  def recursive?
    options['--recursive']
  end

  def check_file(file)
    av_file = ::VideoQuality.new(self, file)
    @videos << av_file if av_file.video?
  end

  def videos_uncached
    @videos = []
    options['<path>'].each do |path|
      check_path(path)
    end
    @videos
  end
end

Runner.run
