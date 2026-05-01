#!/usr/bin/env ruby
# frozen_string_literal: true

require ENV.fetch('RUBY_TO_REQUIRE')

require 'rmagick'

class FileToPerform
  enable_simple_cache
  enable_speaker
  common_constructor :runner, :original_path

  IMAGE_TYPE = 'image'

  def perform
    ::EacRubyUtils::Fs::Temp.on_file(['bg-removed', '.png']) do |temp_file|
      self.temp_file = temp_file
      infom "Performing on \"#{original_path}\"..."
      perform_remove
      perform_trim
    end
  end

  def valid?
    original_path.info.type == IMAGE_TYPE
  end

  protected

  attr_accessor :temp_file

  def env
    ::EacRubyUtils::Envs.local
  end

  def perform_remove
    env.command('rembg', 'i', original_path, temp_file).system!
  end

  def perform_trim
    env.command('convert', temp_file, '-background', 'white', '-fuzz', '20%', '-trim', '+repage',
                '-background', 'white', '-flatten', '-alpha', 'off', output_path).system!
  end

  def output_path
    original_path.parent.join('trimmed-background', original_path.basename).assert_parent
  end
end

class TheRunner
  runner_with :help, :filesystem_traverser do
    desc 'Remove fundo de imagens'
  end

  def run
    start_banner
    files_to_perform.each(&:perform)
    success 'Done'
  end

  protected

  def files_to_perform_uncached
    @files_to_perform = []
    run_filesystem_traverser
    @files_to_perform
  end

  def traverser_check_file(path)
    file = ::FileToPerform.new(self, path)
    @files_to_perform << file if file.valid?
  end

  def start_banner
    infov 'Files to perform', files_to_perform.count
  end
end

TheRunner.run
