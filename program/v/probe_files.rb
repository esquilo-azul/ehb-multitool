#!/usr/bin/env ruby
# frozen_string_literal: true

require ENV.fetch('RUBY_TO_REQUIRE')

require 'ehbrs_ruby_utils/videos/container'
require 'ehbrs_ruby_utils/videos/convert_job'

class ProbeFileRunner
  enable_simple_cache
  enable_speaker
  common_constructor :runner, :source_path do
    run
  end

  private

  def run
    start_banner
    store_probe
  end

  def start_banner
    infov 'Source path', source_path
    infov '  * Target path', target_path
  end

  def store_probe
    target_path.parent.mkpath
    target_path.write(::EacRubyUtils::Yaml.dump(container.info.ffprobe_data))
  rescue ::StandardError => e
    e.print_debug
  end

  def target_path
    runner.target_directory.join(
      "#{source_path.basename.to_s.variableize}.ffprobe.yaml"
    )
  end

  def container_uncached
    ::EhbrsRubyUtils::Videos::Container.new(source_path)
  end
end

class TheRunner
  runner_with :filesystem_traverser do
    desc 'Lê e modifica legendas de um vídeo.'
    arg_opt '-d', '--dir', 'Diretório para saída.'
  end

  def run
    infov 'Parsed', parsed.to_h
    infov 'parsed.recursive?', parsed.recursive?
    infov 'traverser_recursive', traverser_recursive
    run_filesystem_traverser
  end

  def traverser_check_file(file)
    ::ProbeFileRunner.new(self, file)
  end

  private

  def target_directory_uncached
    (parsed.dir || './probe_files').to_pathname
  end
end

TheRunner.run
