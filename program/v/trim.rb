#!/usr/bin/env ruby
# frozen_string_literal: true

require ENV.fetch('RUBY_TO_REQUIRE')

class Runner < Cliutils::DocoptRunner
  enable_speaker
  include ::EacRubyUtils::SimpleCache

  DOC = <<~DOCOPT
    Remove início e final de um vídeo.

    Usage:
      __PROGRAM__ [options] <input>
      __PROGRAM__ -h | --help

    Options:
      -h --help             Show this screen.
      -s --start=<N>        Remove N seconds from start of video.
      -e --end=<N>          Remove N seconds from end of video.
      -o --output=<FILE>    Outputs to FILE.
  DOCOPT

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
    options['--start'].to_f
  end

  def trim_end
    options['--end'].to_f
  end

  def output
    options['--output'] || output_by_input
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
    options['<input>']
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
    ::Cliutils::Videos::File.new(input)
  end
end

Runner.run
