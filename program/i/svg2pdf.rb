#!/usr/bin/env ruby
# frozen_string_literal: true

input = ARGV[0]
output = ARGV[1]

raise 'Input not found' unless input
raise "Input not exist: #{input}" unless File.exist?(input)
raise 'Output not found' unless output

system('inkscape', '-f', input, '-A', output)
