#!/usr/bin/env ruby
# frozen_string_literal: true

w = 4
h = 4

source_file = ARGV[0]
extension = File.extname(source_file)
target_file = File.basename(source_file, extension) + "_#{w}x#{h}#{extension}"

cmd = %w[montage]
(w * h).times do
  cmd << source_file
end

cmd << '-geometry'
cmd << "+#{h}+#{w}"
cmd << target_file

system(*cmd)
