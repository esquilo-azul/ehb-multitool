#!/usr/bin/env ruby
# frozen_string_literal: true

require ENV.fetch('RUBY_TO_REQUIRE')

class TheRunner
  runner_with :help, :filesystem_traverser

  def run
    run_filesystem_traverser
  end

  def traverser_check_file(file)
    song = ::Cliutils::Music::Song.from_file(file)
    return unless song.valid?

    infov song, song.lyrics.found? ? 'found'.light_green : 'not found'.light_black
  end
end

TheRunner.run
