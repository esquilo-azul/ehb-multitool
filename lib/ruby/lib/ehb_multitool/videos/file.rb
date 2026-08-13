# frozen_string_literal: true

module EhbMultitool
  module Videos
    class File
      include ::EacRubyUtils::SimpleCache

      TIME_PATTERN = /(\d+):(\d{2}):(\d{2})(?:\.(\d+))/

      class << self
        def seconds_to_time(seconds)
          t = seconds.floor
          hmsf_to_time(t / 3600, (t / 60) % 60, t % 60, (seconds - t).round(3))
        end

        def time_to_seconds(time)
          m = TIME_PATTERN.match(time)
          raise "Time pattern not find in \"#{time}\"" unless m

          hmsf_to_seconds(m[1], m[2], m[3], m[4])
        end

        private

        def hmsf_to_time(hours, minutes, seconds, fraction)
          r = [hours, minutes, seconds].map { |y| y.to_s.rjust(2, '0') }.join(':')
          r += fraction > 0.0 ? ".#{fraction.to_s.gsub(/\A(0|[^\d])+/, '')}" : '.0'
          r
        end

        def hmsf_to_seconds(hours, minutes, seconds, fraction)
          r = (hours.to_f * 3600) + (minutes.to_f * 60) + seconds.to_f
          r += fraction.to_f / (10**fraction.length) if fraction
          r
        end
      end

      attr_reader :file

      def initialize(file)
        @file = file
      end

      private

      def tracks_uncached
        r = []
        content.each_line do |l|
          t = ::EhbMultitool::Videos::Track.create_if_valid(l)
          r << t if t && t.type != 'Data'
        end
        r
      end

      def content_uncached
        EacRubyUtils::Envs.local.command('ffprobe', @file).execute!(output: :stderr).scrub
      end

      def duration_uncached
        m = /Duration:\s*(#{TIME_PATTERN})/.match(content)
        raise 'Duration pattern not find in content' unless m

        self.class.time_to_seconds(m[1])
      end

      def duration_s_uncached
        self.class.seconds_to_time(duration)
      end
    end
  end
end
