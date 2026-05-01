#!/usr/bin/env ruby
# frozen_string_literal: true

require 'rmagick'

source_file = ARGV[0]
square_file = ARGV[1]
border = ARGV[2].if_present(0, &to_i)

puts "Source: #{source_file}"
puts "Square: #{square_file}"
puts "Border: #{border}"

source = Magick::ImageList.new(source_file).first
square = Magick::ImageList.new(square_file).first

def target_size(source_size, square_size, border)
  (source_size * square_size) - ((source_size - 1) * border)
end

def draw_square(target, square, column, row, border)
  target.composite!(square, column * (square.columns - border), row * (square.rows - border),
                    Magick::ReplaceCompositeOp)
end

target_width = target_size(source.columns, square.columns, border)
target_height = target_size(source.rows, square.rows, border)

refcolor = source.pixel_color(0, 0)
target = Magick::Image.new(target_width, target_height) { self.background_color = refcolor }

source.each_pixel do |pixel, c, r|
  draw_square(target, square, c, r, border) if pixel != refcolor
end

target.write('squares-target.png')
target.display
