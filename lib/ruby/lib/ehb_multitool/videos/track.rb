# frozen_string_literal: true

module EhbMultitool
  module Videos
    class Track
      attr_reader :number, :type, :language, :codec, :extra

      class << self
        def create_if_valid(string)
          new(string)
        rescue ArgumentError
          nil
        end
      end

      def initialize(string)
        m = /\A\s*Stream\s\#(\d+:\d+)(?:\(([^)]+)\))?:\s*([^:]+):\s*([a-z0-9]+)(.*)/.match(string)
        raise ArgumentError unless m

        @input = string.strip
        @number = m[1]
        @type = m[3]
        @language = m[2]
        @codec = m[4]
        @extra = m[5].strip
      end

      def to_s
        r = "[#{type}(#{number}): #{codec}/#{language || '-'}"
        r << " | #{@extra}" if @extra.present?
        r << ']'
        r
      end
    end
  end
end
