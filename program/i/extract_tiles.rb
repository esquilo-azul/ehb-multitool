#!/usr/bin/env ruby
# frozen_string_literal: true

require ENV.fetch('RUBY_TO_REQUIRE')

require 'rmagick'

class V2
  common_constructor :y, :x do
    self.y = y.to_i
    self.x = x.to_i
  end

  def *(other)
    self.class.new(y * other.y, x * other.x)
  end

  def to_s
    "#{y}/#{x}"
  end
end

class Tile
  enable_simple_cache
  enable_speaker
  common_constructor :runner, :coord
  delegate :tile_size, to: :runner

  def perform
    infov 'Coord.', coord
    target_file.parent.mkpath
    image.write(target_file)
  end

  def target_file
    runner.output_dir.join("#{coord.y}_#{coord.x}.png")
  end

  private

  def image_uncached
    runner.image.crop(source_offset.x, source_offset.y, tile_size.x, tile_size.y)
  end

  def source_offset
    coord * tile_size
  end
end

class TheRunner
  DEFAULT_TILE_WIDTH = DEFAULT_TILE_HEIGHT = 16

  runner_with :help do
    desc 'Extrai tiles de uma imagem.'
    arg_opt '-C', '--output-dir', 'Caminho para o diretório de saída'
    arg_opt '-w', '--width', 'Largura do tile.', default: DEFAULT_TILE_WIDTH
    arg_opt '-H', '--height', 'Largura do tile.', default: DEFAULT_TILE_HEIGHT
    pos_arg :source_file
  end

  def run
    infov 'Source file', source_file
    infov 'Source size', image_size
    infov 'Tile size', tile_size.to_s
    tiles.each(&:perform)
  end

  def image_uncached
    ::Magick::ImageList.new(source_file).first
  end

  def image_size_uncached
    ::V2.new(image.rows, image.columns)
  end

  def source_file
    parsed.source_file.to_pathname
  end

  def output_dir
    parsed.output_dir.if_present(&:to_pathname) ||
      source_file.basename_sub { |v| "#{v}_tiles_extract" }
  end

  def tiles
    tiles_v_count.times.flat_map do |y|
      tiles_h_count.times.map do |x|
        ::Tile.new(self, ::V2.new(y, x))
      end
    end
  end

  def tiles_v_count
    image_size.y / tile_size.y
  end

  def tiles_h_count
    image_size.x / tile_size.x
  end

  def tile_size_uncached
    ::V2.new(parsed.height, parsed.width)
  end
end

TheRunner.run
