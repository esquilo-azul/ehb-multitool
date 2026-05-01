#!/usr/bin/env ruby
# frozen_string_literal: true

require ENV.fetch('RUBY_TO_REQUIRE')

require 'rmagick'

class Runner
  runner_with :help do
    desc 'Converte para escala de cinza.'
    pos_arg :input
    pos_arg :output, optional: true
  end

  OPTIONS = {
    new: '--new', confirm: 'run', stereotype: '--stereotype'
  }.freeze

  private

  def run
    infov('Input', input)
    infov('Output', output)
    ::EacRubyUtils::Envs.local.command('convert', '-density', '600', '-colorspace', 'Gray',
                                       input, output).system!
  end

  def input
    parsed.input
  end

  def output
    parsed.output || output_by_input
  end

  def output_by_input
    ext = ::File.extname(input)
    "#{::File.basename(input, ext)}_greyscale#{ext}"
  end
end

Runner.run
