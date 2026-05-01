#!/usr/bin/env ruby
# frozen_string_literal: true

require ENV.fetch('RUBY_TO_REQUIRE')
require 'ehbrs_ruby_utils/videos/file'

class Audio
  enable_simple_cache
  enable_speaker
  common_constructor :runner, :path

  # @return [Boolean]
  def valid?
    streams.any?
  end

  protected

  def file_uncached
    ::EhbrsRubyUtils::Videos::File.new(path)
  end

  def streams_uncached
    file.audios.map { |stream| ::Stream.new(self, stream) }
  end
end

class AudioSet
  def add_audio(audio)
    audio.streams.each do |stream|
      bit_rate(stream.bit_rate_value).add_stream(stream)
    end
  end

  def bit_rates
    @bit_rates ||= {}
  end

  def streams_count
    bit_rates.values.inject(0) { |a, e| a + e.streams.count }
  end

  protected

  def bit_rate(value)
    bit_rates[value] = ::BitRate.new(value) unless bit_rates.key?(value)
    bit_rates.fetch(value)
  end
end

class BitRate
  common_constructor :value

  def add_stream(stream)
    streams << stream
  end

  def streams
    @streams ||= []
  end
end

class BitRateStaticValue
  VALUES = [32, 40, 48, 56, 64, 80, 96, 112, 128, 160, 192, 224, 256, 320].freeze

  class << self
    enable_simple_cache

    def find(variable_value)
      values.find { |static_value| static_value.accept?(variable_value) } || ibr
    end

    protected

    def values_uncached
      before = nil
      VALUES.each_with_object([]) do |e, a|
        vv = new(e, before)
        before.after = vv if before
        before = vv
        a << vv
      end
    end
  end

  attr_accessor :after

  common_constructor :value, :before
  compare_by :value

  def accept?(variable_value)
    greather_or_equal_to_min(variable_value) && lesser_than_max(variable_value)
  end

  def greather_or_equal_to_min(variable_value)
    min.if_present(true) do |x|
      multivv(variable_value) >= x
    end
  end

  def lesser_than_max(variable_value)
    max.if_present(true) do |x|
      multivv(variable_value) < x
    end
  end

  def max
    after.if_present(nil) do |e|
      value + ((e.value - value) / 2)
    end
  end

  def min
    before.if_present(nil, &:max)
  end

  def multivv(variable_value)
    (variable_value / 1000.0).round
  end

  def to_s
    "#{value}kbps"
  end
end

class Stream
  enable_simple_cache
  common_constructor :file, :stream

  def probe_bit_rate_value
    stream.ffprobe_data.fetch(:bit_rate).to_i
  end

  def to_s
    [file.path, stream.index, probe_bit_rate_value].map { |s| s.to_s.white }.join(' | '.blue)
  end

  protected

  def bit_rate_value_uncached
    ::BitRateStaticValue.find(probe_bit_rate_value)
  end
end

class TheRunner
  runner_with :help, :filesystem_traverser

  def run
    run_filesystem_traverser
    infov 'Streams found', audio_set.streams_count
    show_bit_rates
  end

  def traverser_check_file(file)
    audio = ::Audio.new(self, file)
    audio_set.add_audio(audio) if ::Audio.new(self, file).valid?
  end

  protected

  def audio_set_uncached
    ::AudioSet.new
  end

  def show_bit_rate(bit_rate)
    infov 'Bit rate', bit_rate.value
    bit_rate.streams.each do |stream|
      infov '  * ', stream
    end
  end

  def show_bit_rates
    audio_set.bit_rates.each_value do |bit_rate|
      show_bit_rate(bit_rate)
    end
  end
end

TheRunner.run
