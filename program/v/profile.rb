#!/usr/bin/env ruby
# frozen_string_literal: true

require ENV.fetch('RUBY_TO_REQUIRE')

class VideoFileConvert
  enable_speaker
  include ::EacRubyUtils::SimpleCache

  attr_reader :input, :profile

  def initialize(input, profile)
    @input = input
    @profile = profile
  end

  def run
    banner

    if File.exist?(target)
      warn "Alvo já existe: #{target}"
    else
      convert
    end
  end

  private

  def banner
    info '------------------------------'
    infov('Input', input)
    infov('Target', target)
  end

  def dirname
    ::File.dirname(input)
  end

  def target_uncached
    ::File.join(dirname, "#{File.basename(input, '.*')}.#{profile.extension}")
  end

  def input_converted
    "#{input}.converted"
  end

  def convert
    profile.convert(input)
  end
end

class Runner < Cliutils::DocoptRunner
  enable_speaker
  include ::EacRubyUtils::SimpleCache

  DOC = <<~DOCOPT
    Usage:
      __PROGRAM__ --profile=<profile> <files>...
      __PROGRAM__ -h | --help

    Options:
      -h --help             Show this screen
      -p --profile=<profile> Perfil de vídeo

    Profiles:
    %%PROFILES%%
  DOCOPT

  def doc
    DOC.gsub('%%PROFILES%%', all_profiles_names.map { |n| "  * #{n}" }.join("\n"))
  end

  private

  def run
    fatal_error(invalid_message) if invalid_message.present?
    inputs.each { |input| ::Cliutils::Videos::ConvertJob.new(input, profile).run }
  end

  def invalid_message_uncached
    "Invalid profile: \"#{profile_name}\" (#{all_profiles_names})" if profile.blank?
  end

  def profile_uncached
    ::Cliutils::Videos::FfmpegProfile.by_name(profile_name)
  end

  def profile_name
    options.fetch('--profile')
  end

  def all_profiles_names
    ::Cliutils::Videos::FfmpegProfile.all.map(&:name)
  end

  def inputs
    options['<files>']
  end
end

Runner.run
