#!/usr/bin/env ruby
# frozen_string_literal: true

require ENV.fetch('RUBY_TO_REQUIRE')

class Runner
  runner_with :help do
    desc 'Remove início e final de um vídeo.'
    arg_opt '-s', '--start', 'Remove N seconds from start of video.'
    arg_opt '-e', '--end', 'Remove N seconds from end of video.'
    arg_opt '-o', '--output', 'Outputs to FILE.'
    pos_arg :input
  end

  private

  def run
    if trim_start > 0.0 || trim_end > 0.0
      run_trim
    else
      info('No trim to realize')
    end
  end

  def start_banner
    infov('Input', input)
    infov('Input duration', video.duration_s)
    infov('Output', output)
    infov('Trim start', trim_start)
    infov('End start', trim_end)
    infov('Start time', start_time)
    infov('Duration', duration)
  end

  def trim_start
    parsed.start.to_f
  end

  def trim_end
    parsed.end.to_f
  end

  def output
    parsed.output || output_by_input
  end

  def output_by_input
    ext = ::File.extname(input)
    base = "#{::File.basename(input, ext)}_trimmed"
    dir = ::File.dirname(input)
    i = nil
    loop do
      r = ::File.join(dir, "#{base}#{i}#{ext}")
      return r unless ::File.exist?(r)

      i = i.nil? ? 0 : i + 1
    end
  end

  def input
    parsed.input
  end

  def run_trim
    ::EacRubyUtils::Envs.local.command('ffmpeg', '-i', input, '-ss', start_time, '-t', duration,
                                       '-codec', 'copy', output).execute!
  end

  def start_time
    trim_start.to_s
  end

  def duration
    (video.duration - trim_start - trim_end).to_s
  end

  def video_uncached
    ::EhbMultitool::Videos::File.new(input)
  end
end

Runner.run
