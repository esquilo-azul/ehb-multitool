# frozen_string_literal: true

module EhbMultitool
  module Videos
    class Quality
      enable_simple_cache
      include ::Comparable

      UNFOUND_NAME = '?'

      LIST = [240, 480, 720, 1080, 2160].freeze

      class << self
        enable_simple_cache

        private

        def list_uncached
          previous = nil
          LIST.map { |height| previous = new(height, previous) }
        end
      end

      common_constructor :height, :previous
      attr_reader :next

      set_callback :initialize, :after do
        previous&.send('next=', self)
      end

      delegate :to_s, to: :height

      def resolution_match(res)
        rm = ResolutionMatch.new(self, res)
        rm.signal.nil? ? nil : rm
      end

      private

      attr_writer :next

      def negative_margin
        previous.try(:height).if_null(0)
      end

      def positive_margin
        self.next.try(:height).if_null(height * 2)
      end

      class ResolutionMatch
        enable_simple_cache
        common_constructor :quality, :resolution

        def signal
          return nil if rate.nil?
          return 1 if rate > 0.0
          return -1 if rate < 0.0

          0
        end

        def to_s
          case signal
          when 0 then quality.to_s
          when 1 then quality.to_s + (quality.next ? "..#{quality.next}" : '')
          else 'UNDEFINED'
          end
        end

        private

        def rate_uncached
          equal_rate || positive_rate
        end

        def equal_rate
          resolution.lower == quality.height ? 0 : nil
        end

        def negative_rate
          return nil unless resolution.lower < quality.height
          return nil if quality.previous && resolution.lower <= quality.previous.height

          -1
        end

        def positive_rate
          return nil unless resolution.lower > quality.height
          return nil if quality.next && resolution.lower >= quality.next.height

          1
        end
      end
    end
  end
end
