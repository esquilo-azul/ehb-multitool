#!/usr/bin/env ruby
# frozen_string_literal: true

require 'rmagick'

class BgTile
  attr_reader :bg_file, :tile_file

  def initialize(bg_file, tile_file)
    @bg_file = bg_file
    @tile_file = tile_file
  end

  def run
    target.write(target_file)
    target.display
  end

  private

  def target_file
    "#{File.basename(tile_file, File.extname(tile_file))}_merged.jpg"
  end

  def target
    @target ||= tile_bg.composite(bg, Magick::NorthWestGravity, Magick::OverCompositeOp)
  end

  def tile_bg
    @tile_bg ||= begin
      t = ::Magick::Image.new(bg.columns, bg.rows)
      y = 0
      while y < t.rows
        tile_bg_row(y, t)
        y += tile.rows
      end
      t
    end
  end

  def tile_bg_row(y_coord, tile_image)
    x = 0
    while x < tile_image.columns
      tile_image.composite!(tile, x, y_coord, Magick::OverCompositeOp)
      x += tile.columns
    end
  end

  def bg
    @bg ||= begin
      b = ::Magick::ImageList.new(bg_file).first
      b.alpha(Magick::ActivateAlphaChannel)
      b
    end
  end

  def tile
    @tile ||= begin
      t = ::Magick::ImageList.new(tile_file).first
      t.alpha(Magick::ActivateAlphaChannel)
      t
    end
  end
end

BgTile.new(ARGV[0], ARGV[1]).run
