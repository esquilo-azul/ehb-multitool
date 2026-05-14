#!/usr/bin/env ruby
# frozen_string_literal: true

require ENV.fetch('RUBY_TO_REQUIRE')

class TheRunner
  enable_jobs_runner
  runner_with :help do
    desc 'Trata músicas selecionadas'
    bool_opt '-b', '--build', 'Constrói diretório de músicas selecionadas.'
    bool_opt '-S', '--spread', 'Aplica o spread.'
    bool_opt '-s', '--sort', 'Aplica o sort.'
    bool_opt '-y', '--yes', 'Executa sem pedir confirmação.'
  end

  def run
    run_jobs :select, :write_sort_file, :spread_apply, :sort_apply
  end

  private

  def build_dir_uncached
    ENV.fetch('EHBRSDISK_CARRO_SOURCE_PATH').to_pathname
  end

  def select
    args = parsed.build? ? ['--build-dir', build_dir] : []
    args << '--yes' if parsed.yes?
    args += [ENV.fetch('BBFLN_100_MUSIC_ROOT')]
    ::Cliutils::Core.command('s/ehbrs-tools', 'music', 'selected', *args).system!
  end

  def spreaded_albums
    ::Cliutils::Core.command('o/ehb/erd/carro/spread', '--ids').execute!.each_line.map(&:strip)
      .compact_blank
  end

  # @return [Boolean]
  def run_spread_apply?
    parsed.spread?
  end

  def spread_apply
    sort_source_file.write(sort_content_by_spread)
  end

  def sort_apply
    return unless parsed.sort?

    ::Cliutils::Core.command('/s/ehbrs-tools', 'music', 'sort', '--path', sort_target_file.parent,
                             'load').system!
  end

  def sort_content_by_spread
    ::EacRubyUtils::Yaml.dump('A' => spreaded_albums)
  end

  def sort_source_file
    ::Cliutils.application.config_dir.join(ENV.fetch('EHBRSDISK_CARRO_ID')).join('sort.yaml')
  end

  def sort_target_file
    build_dir.join('.sort')
  end

  def write_sort_file
    return unless parsed.build?

    sort_source_file.parent.mkpath
    ::FileUtils.touch(sort_source_file.to_path)
    ::FileUtils.ln_sf(sort_source_file.to_path, sort_target_file.to_path)
  end
end

TheRunner.run
