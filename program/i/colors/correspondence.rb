#!/usr/bin/env ruby
# frozen_string_literal: true

require ENV.fetch('RUBY_TO_REQUIRE')

class Color
  include ::Comparable

  common_constructor :from_color

  def <=>(other)
    from_color <=> other.from_color
  end

  def eql?(other)
    self.<=>(other).zero?
  end

  delegate :hash, to: :from_color

  def add(to_color)
    to_color_set << to_color
  end

  def to_colors
    to_color_set.to_a.sort
  end

  def to_output
    ([from_color] + to_colors).map(&:to_html).join(':')
  end

  private

  def to_color_set
    @to_color_set ||= ::Set.new
  end
end

class ColorSet
  def colors
    color_set.values.sort
  end

  def add(from_color, to_color)
    color(from_color).add(to_color)
  end

  def color(from_color)
    color_set[from_color] ||= ::Color.new(from_color)
    color_set[from_color]
  end

  private

  def color_set
    @color_set ||= {}
  end
end

class TheRunner
  runner_with :help, :output do
    pos_arg :from_file
    pos_arg :to_file
  end

  def run
    start_banner
    fatal_error 'Size mismatch' if size_mismatch?
    run_output
  end

  def size_mismatch?
    from_image.size != to_image.size
  end

  def output_content
    color_set.colors.map { |v| "#{v.to_output}\n" }.join
  end

  private

  def start_banner
    infov 'From file', parsed.from_file + " (#{from_image.size})"
    infov 'To file', parsed.to_file + " (#{to_image.size})"
  end

  def from_image_uncached
    ::Cliutils::Images::Base.from_file(parsed.from_file)
  end

  def to_image_uncached
    ::Cliutils::Images::Base.from_file(parsed.to_file)
  end

  def color_set_uncached
    r = ::ColorSet.new
    from_image.size.times do |coord|
      r.add(from_image.pixel(coord).color, to_image.pixel(coord).color)
    end
    r
  end
end

TheRunner.run
