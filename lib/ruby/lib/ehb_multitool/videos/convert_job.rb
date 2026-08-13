# frozen_string_literal: true

module EhbMultitool
  module Videos
    class ConvertJob
      enable_simple_cache
      enable_speaker

      FORMATS_TO_EXTENSIONS = {
        'matroska' => '.mkv'
      }.freeze

      attr_reader :input, :profile

      def initialize(input, profile)
        @input = input
        @profile = profile
      end

      def run
        if ::File.exist?(converted)
          warn("Converted file already exist: \"#{converted}\"")
        else
          profile.run_callbacks(:convert) { convert }
          profile.run_callbacks(:swap) { swap }
        end
      end

      def target
        ::File.join(::File.dirname(input), "#{File.basename(input, '.*')}#{target_extension}")
      end

      private

      def command_args_uncached
        r = ['ffmpeg', '-i', input] + profile_ffmpeg_args
        r += ['-f', format_by_input] if format_by_args.blank?
        r + [converting]
      end

      def convert
        infov 'Convert args', command_args.shelljoin
        ::EacRubyUtils::Envs.local.command(*command_args).system!
      end

      def format_by_args_uncached
        profile_ffmpeg_args.rindex('-f').if_present do |option_index|
          profile_ffmpeg_args[option_index + 1]
        end
      end

      def format_by_input
        r = FORMATS_TO_EXTENSIONS.invert[target_extension_by_input]
        return if r.present?

        target_extension_by_input.gsub(/\A\./, '')
      end

      def format_to_extension(format)
        FORMATS_TO_EXTENSIONS[format].if_present(".#{format}")
      end

      def profile_ffmpeg_args_uncached
        profile.ffmpeg_args
      end

      def swap
        ::FileUtils.mv(input, converted)
        ::FileUtils.mv(converting, target)
      end

      def converting
        "#{target}.converting"
      end

      def converted
        "#{input}.converted"
      end

      def target_extension
        target_extension_by_args || target_extension_by_input
      end

      def target_extension_by_args
        format_by_args.if_present { |v| format_to_extension(v) }
      end

      def target_extension_by_input
        ::File.extname(input)
      end
    end
  end
end
