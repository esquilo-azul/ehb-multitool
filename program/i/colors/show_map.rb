#!/usr/bin/env ruby
# frozen_string_literal: true

require ENV.fetch('RUBY_TO_REQUIRE')

require 'rmagick'

class TheRunner
  runner_with :help do
    desc 'Mostra a paleta de cores de uma imagem'
    bool_opt '-p', '--pixels', 'Consulta todos os pixels no lugar do colormap.'
    pos_arg :source_file
  end

  def run
    infov 'Source file', parsed.source_file
    infov 'Colors', colors.count
    colors.each do |color|
      infov '  * ', color
    end
  end

  def image_uncached
    ::Magick::ImageList.new(parsed.source_file).first
  end

  def colors_uncached
    parsed.pixels? ? colors_by_pixels : colors_by_colormap
  end

  def colors_by_colormap
    image.colors.times.map { |index| image.colormap(index) }
  end

  def colors_by_pixels
    r = ::Set.new
    image.columns.times do |x|
      image.rows.times do |y|
        r << image.pixel_color(x, y)
      end
    end
    r
  end
end

TheRunner.run
