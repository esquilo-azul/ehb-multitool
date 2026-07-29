#!/usr/bin/env ruby
# frozen_string_literal: true

require ENV.fetch('RUBY_TO_REQUIRE')

require 'filesize'

class Runner
  runner_with :help do
    desc 'Mostra o espaço usado ignorando os diretórios de "dropbox exclude".'
    arg_opt '-m', '--max-level', 'Max level.'
  end

  private

  def run
    s = visit('.')
    puts '------------------'
    puts 'Total'.green + ": #{size_pretty(s)}"
  end

  def visit(path)
    if ::File.symlink?(path)
      0
    elsif File.directory?(path)
      visit_directory(path)
    else
      File.size(path)
    end
  end

  def visit_directory(dir)
    s = 0
    dir = dir.gsub(%r{\A\./}, '')
    if excluded.include?(dir)
      puts "Excluded: #{dir.yellow}"
      return 0
    end
    s += visit_directory_entries(dir)
    show_dir(dir, s)
    s
  end

  def visit_directory_entries(dir)
    s = 0
    Dir.entries(dir).sort.each do |d|
      next if %w[. ..].include?(d)

      s += visit("#{dir}/#{d}")
    end
    s
  end

  def show_dir(dir, size)
    return unless show_dir?(dir)

    puts "#{dir.green}: #{size_pretty(size)}"
  end

  def size_pretty(size)
    Filesize.from("#{size} B").pretty
  end

  def excluded_uncached
    r = []
    ::EacRubyUtils::Envs.local.command('dropbox', 'exclude').execute!.each_line do |l|
      l.strip!
      next if l == 'Excluded:'

      r << l
    end
    r
  end

  def show_dir?(dir)
    return false if dir =~ %r{(/|\A)\.}
    return false if dir.count('/') > max_level

    true
  end

  def max_level
    parsed.max_level.to_i
  end
end

Runner.run
