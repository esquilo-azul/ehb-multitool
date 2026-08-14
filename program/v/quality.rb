#!/usr/bin/env ruby
# frozen_string_literal: true

require ENV.fetch('RUBY_TO_REQUIRE')

class VideoQuality < EhbrsRubyUtils::Videos::File
  enable_speaker
  enable_memoized

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

    infov path, quality_info
  end

  def output_file
    out("#{path}\n") if output_file?
  end

  private

  def output_file?
    (ok? && runner.output_ok?) || (!ok? && runner.output_not_ok?)
  end

  def ok?
    frame_rate_result.success? && resolution_result.success?
  end

  memoize def video_track
    streams.find(&:video?)
  end

  def quality_info
    [resolution_result.label, frame_rate_result.label, resolution.resolution_to_s,
     resolution.ratio, frame_rate, video_track.codec_name].join(' | ')
  end

  memoize def resolution
    ::EhbMultitool::Videos::Resolution.new(video_track.width, video_track.height)
  end

  memoize def frame_rate
    video_track.ffprobe_data.fetch(:r_frame_rate).gsub(%r{/.*\z}, '').to_f
  end

  memoize def frame_rate_result
    ::Avm::Result.success_or_error("#{frame_rate} FPS", frame_rate >= runner.frame_rate_minimum)
  end

  memoize def resolution_result
    ::Avm::Result.success_or_error(
      resolution.quality_match.to_s,
      resolution.quality.height >= runner.height_minimum
    )
  end
end

class Runner
  include ::Cliutils::Fs::CheckDirectoryOrFile

  runner_with :help do
    desc 'Mostra a qualidade de vídeos.'
    pos_arg :path, repeat: true
    bool_opt '-r', '--recursiver', 'Recursive.'
    arg_opt '-f', '--frame-rate-min', 'Minimum frame rate to check.',
            default: 23.0
    arg_opt '-H', '--height-min', 'Minimum height.', default: 720
    bool_opt '-o',                                    'Output files.'
    bool_opt '-y',                                    'Output only ok files.'
    bool_opt '-n', 'Output only not ok files.'
  end

  def frame_rate_minimum
    parsed.frame_rate_min.to_f
  end

  def height_minimum
    parsed.height_min.to_f
  end

  def output?
    parsed.o?
  end

  def output_ok?
    parsed.y? || !parsed.n?
  end

  def output_not_ok?
    parsed.n? || !parsed.y?
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
    parsed.recursive?
  end

  def check_file(file)
    av_file = ::VideoQuality.new(self, file)
    @videos << av_file if av_file.video?
  end

  memoize def videos
    @videos = []
    parsed.path.each do |path|
      check_path(path)
    end
    @videos
  end
end

Runner.run
