# frozen_string_literal: true

module EhbMultitool
  module Videos
    class Resolution
      enable_simple_cache
      include ::Comparable

      MAX_DIMENSION = 8192
      MIN_DIMENSION = 32

      class << self
        def valid_dimension?(dimension)
          dimension.between?(MIN_DIMENSION, MAX_DIMENSION)
        end
      end

      common_constructor :width, :height

      def <=>(other)
        pixels <=> other.pixels
      end

      def valid?
        [width, height].all? { |d| self.class.valid_dimension?(d) }
      end

      def to_s
        "#{name} - #{resolution_to_s} - #{ratio}"
      end

      def resolution_to_s
        "#{width}x#{height}"
      end

      def ratio
        (width.to_r / height.to_r).to_s.tr('/', ':')
      end

      def pixels
        width * height
      end

      def lower
        [width, height].min
      end

      delegate :quality, to: :quality_match

      private

      def name_uncached
        ::EhbMultitool::Videos::Quality.find_name(self)
      end

      def quality_match_uncached
        ::EhbMultitool::Videos::Quality.list.each do |q|
          rm = q.resolution_match(self)
          return rm unless rm.nil?
        end
        raise "Quality not found for #{self}"
      end
    end
  end
end
