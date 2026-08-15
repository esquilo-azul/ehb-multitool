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

class Runner
  runner_with :help do
    arg_opt '-p', '--profile', 'Perfil de vídeo'
    pos_arg :file, repeat: true
  end

  def help_extra_text
    "Profiles:\n#{all_profiles_names.map { |n| "  * #{n}" }.join("\n")}"
  end

  private

  def run
    fatal_error(invalid_message) if invalid_message.present?
    inputs.each { |input| ::EhbMultitool::Videos::ConvertJob.new(input, profile).run }
  end

  def invalid_message_uncached
    "Invalid profile: \"#{profile_name}\" (#{all_profiles_names})" if profile.blank?
  end

  def profile_uncached
    ::EhbMultitool::Videos::FfmpegProfile.by_name(profile_name)
  end

  def profile_name
    parsed.profile
  end

  def all_profiles_names
    ::EhbMultitool::Videos::FfmpegProfile.all.map(&:name)
  end

  def inputs
    parsed.file
  end
end

Runner.run
