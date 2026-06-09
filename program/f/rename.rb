#!/usr/bin/env ruby
# frozen_string_literal: true

require ENV.fetch('RUBY_TO_REQUIRE')

module ReplaceOperation
  def replace(name)
    return name unless replace?

    if replace_pattern.is_a?(::Regexp)
      replace_with_regex(name)
    else
      replace_with_plain(name)
    end
  end

  private

  def replace?
    replace_pattern.present?
  end

  def replace_with_regex(name)
    m = replace_pattern.match(name)
    return name unless m

    r = name.gsub(replace_pattern, replace_by)
    m.length.times do |index|
      r = r.gsub("\\#{index}", m[index])
    end
    r
  end

  def replace_with_plain(name)
    name.gsub(replace_pattern, replace_by)
  end

  def replace_pattern
    options.fetch(:replace_pattern)
  end

  def replace_by
    options.fetch(:replace_by).to_s
  end
end

class FileRename
  include ::ReplaceOperation

  attr_reader :file, :options

  def initialize(file, options)
    @file = file
    @options = options
    run
  end

  private

  def line_out
    rename? ? "#{new_basename} <= #{basename}" : basename.light_black
  end

  def run
    puts line_out
    rename if options.fetch(:confirm)
  end

  def rename?
    new_basename != basename
  end

  def rename
    return unless rename?

    new_path.to_pathname.assert_parent if options.fetch(:mkdir_parent)
    ::FileUtils.mv(file, new_path)
  end

  def new_path
    ::File.join(::File.dirname(file), new_basename)
  end

  def basename
    ::File.basename(file)
  end

  def new_basename
    r = basename
    r.gsub!(options.fetch(:delete), '') if options.fetch(:delete)
    replace(r)
  end
end

class Runner
  include ::Cliutils::Fs::CheckDirectoryOrFile

  runner_with :help do
    desc 'Renomeia arquivos em lote'
    bool_opt '-R', '--recursive', 'Recursivo.'
    arg_opt '-d', '--delete', 'Remove <part> do nome do arquivo.'
    bool_opt '-c', '--confirm', 'Confirma a renomeação.'
    arg_opt '-r', '--replace', 'Substitui <pattern> por <replace-by>.'
    arg_opt '-b', '--replace-by', 'Substitui <pattern> por <replace-by>.'
    bool_opt '--regex', 'Utiliza REGEX em --replace.'
    bool_opt '-m', '--mkdir-parent', 'Cria os diretórios do caminho alvo.'
    pos_arg :path, repeat: true
  end

  def run
    parsed.path.each { |path| check_path(path) }
  end

  private

  def check_file(path)
    ::FileRename.new(path, rename_options)
  end

  def recursive?
    parsed.recursive?
  end

  def rename_options
    { delete: parsed.delete, confirm: parsed.confirm?,
      replace_pattern: replace_pattern, replace_by: replace_by, mkdir_parent: parsed.mkdir_parent? }
  end

  def replace_pattern
    return nil if parsed.replace.blank?
    return parsed.replace unless parsed.regex?

    ::Regexp.new(parsed.replace)
  end

  def replace_by
    parsed.replace_by
  end
end

Runner.run
