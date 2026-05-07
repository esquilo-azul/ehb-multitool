#!/usr/bin/env ruby
# frozen_string_literal: true

require ENV.fetch('RUBY_TO_REQUIRE')

class PatchFile
  enable_speaker

  VALID_EXTNAMES = %w[.bps .ips .xdelta].freeze

  common_constructor :runner, :path do
    self.path = path.to_pathname
  end

  def run
    return unless valid?

    infov 'Patch found', path
    do_patch
  end

  def valid?
    VALID_EXTNAMES.include?(path.extname.downcase)
  end

  def do_patch
    ::Cliutils::Core.command('s/ehbrs-tools', 'vg', 'patch', runner.source_rom, path).system!
  end
end

class TheRunner
  include ::EacCli::Runner

  DEFAULT_TRAVERSER_RECURSIVE = true

  runner_definition do
    pos_arg :source_rom
  end

  runner_with :help, :filesystem_traverser

  def run
    infov 'Source rom', source_rom
    run_filesystem_traverser
  end

  def traverser_check_file(file)
    ::PatchFile.new(self, file).run
  end

  def source_rom
    parsed.source_rom.to_pathname
  end
end

TheRunner.run
