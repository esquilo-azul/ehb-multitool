#!/usr/bin/env ruby
# frozen_string_literal: true

require ENV.fetch('RUBY_TO_REQUIRE')

class TheRunner
  enable_jobs_runner
  runner_with :help do
    desc 'Converte PDF para imagem.'
    pos_arg :input_path
    pos_arg :output_path
  end

  attr_reader :build_dir

  def run
    on_build_dir do
      input_to_images
      images_to_output
    end
    infov 'Output file', parsed.output_path
    success 'Done!'
  end

  def on_build_dir
    # ::EacRubyUtils::Fs::Temp.on_directory do |dir|
    # @build_dir = dir
    @build_dir = ::Pathname.new('/tmp/pdf_to_images')
    ::FileUtils.rm_rf(@build_dir)
    @build_dir.mkpath
    yield
    # end
  end

  def input_to_images
    infom 'INPUT TO IMAGES'
    env.command('convert', '-density', '300', parsed.input_path, '-quality', '100',
                build_dir.join('temp.png')).system!
    env.command('tree', build_dir).system!
  end

  def images_to_output
    infom 'IMAGES TO OUTPUT'
    env.command('convert', *images, '-append', parsed.output_path).system
  end

  def images
    build_dir.children.sort_by { |p| [parse_image_name(p)] }
  end

  def env
    ::EacRubyUtils::Envs.local
  end

  def parse_image_name(image_path)
    m = /\Atemp-(\d+)\.png\z/.match(image_path.basename.to_path)
    return m[1].to_i if m

    raise "Does not match the pattern: #{image_path}"
  end
end

TheRunner.run
