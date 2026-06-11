#!/usr/bin/env ruby
# frozen_string_literal: true

require ENV.fetch('RUBY_TO_REQUIRE')

require 'rmagick'

class SourceFile
  enable_speaker
  enable_simple_cache
  common_constructor :runner, :path

  def move?
    target_current_relative_path.if_present(false) { |v| relative_path != v }
  end

  def perform
    return unless move?

    puts [relative_path, target_current_relative_path].join(' | '.blue)
    do_move
  end

  def relative_path
    path.relative_path_from(runner.source)
  end

  def target_new_path
    runner.target.join(relative_path)
  end

  def target_current_relative_path
    target_current_path.if_present { |v| v.relative_path_from(runner.target) }
  end

  private

  def do_move
    target_new_path.parent.mkpath
    ::FileUtils.mv(target_current_path, target_new_path)
  end

  def target_current_path_uncached
    runner.target.glob('**/*').find { |v| v.basename == path.basename }
  end
end

class TheRunner
  runner_with :help do
    pos_arg :source
    pos_arg :target
  end

  def run
    source.glob('**/*').each { |path| ::SourceFile.new(self, path).perform }
  end

  def source
    parsed.source.to_pathname
  end

  def target
    parsed.target.to_pathname
  end
end

TheRunner.run
