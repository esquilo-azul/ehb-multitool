#!/usr/bin/env ruby
# frozen_string_literal: true

require ENV.fetch('RUBY_TO_REQUIRE')

class TheRunner
  runner_with :help do
    bool_opt '-O', '--open'
    pos_arg :file
  end

  def run
    run_build
    run_open if parsed.open?
  end

  private

  # @return [EacRubyUtils::Envs::Command]
  def build_command
    build_executable.command('--out-file', target_file, parsed.file)
  end

  # @return [EacRubyUtils::Envs::Executable]
  def build_executable
    ::Cliutils::Executables.asciidoctor
  end

  # @return [EacRubyUtils::Envs::Command]
  def open_command
    open_executable.command(target_file)
  end

  # @return [EacRubyUtils::Envs::Executable]
  def open_executable
    ::Cliutils::Executables.xdg_open
  end

  def run_build
    build_command.system!
  end

  def run_open
    open_command.system!
  end

  def target_file
    ::Pathname.new('/tmp/asciidoctor.html')
  end
end

TheRunner.run
