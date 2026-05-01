#!/usr/bin/env ruby
# frozen_string_literal: true

require ENV.fetch('RUBY_TO_REQUIRE')

require 'rmagick'

class ImageFile
  enable_simple_cache
  enable_speaker
  common_constructor :runner, :path do
    self.path = path.to_pathname
  end

  def perform
    infov 'Image file', path

    return unless runner.confirm?

    target_path.parent.mkpath
    new_image.write(target_path)
  end

  private

  def image_uncached
    ::Magick::ImageList.new(path).first
  end

  def new_image
    runner.colors.replace_in_image(image)
  end

  def target_path
    runner.target_dir.join(path.basename)
  end
end

class TheRunner
  runner_with :help do
    desc 'Substitui as cores de imagens.'
    bool_opt '-c', '--confirm', 'Confirma a substituição.'
    arg_opt '-C', '--color', 'Substituição de cor no formato "FFFFFF:000000".', repeat: true
    arg_opt '-f', '--colors-file', 'Adiciona cores de <file>.'
    arg_opt '-t', '--target-dir', 'Diretório alvo', default: 'replace_colors_target_dir'
    pos_arg :files, repeat: true
  end

  def run
    infov 'Files', files.count
    infov 'Target directory', target_dir
    infov 'Colors to replace', colors.count
    colors.singles.each { |c| infov '  * ', c }
    files.each(&:perform)
  end

  delegate :confirm?, to: :parsed

  def target_dir
    parsed.target_dir.to_pathname
  end

  private

  def files_uncached
    parsed.files.map { |path| ::ImageFile.new(self, path) }
  end

  def colors_uncached
    r = ::Cliutils::Colors::Replacement::Set.new
    r.add_from_file(parsed.colors_file) if parsed.colors_file.present?
    parsed.color.each { |c| r.add_from_string(c) }
    r
  end
end

TheRunner.run
