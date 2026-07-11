# frozen_string_literal: true

module EhbMultitool
  module Compras
    module GoogleSpreadsheetFormulas
      class State
        class << self
          # @return [String]
          def stringfy(object)
            ['"', object, '"'].join
          end
        end

        common_constructor :index, :text
        compare_by :text
        delegate :stringfy, to: :class

        # @return [Symbol]
        def key
          text.variableize.to_sym
        end

        # @param text [String]
        # @param regexp [String]
        # @return [String]
        def text_equal_to(value)
          "exact(#{self}; #{value})"
        end

        # @return [String]
        def text_to_s
          stringfy(text)
        end

        # @return [String]
        def to_s
          stringfy([(index + 1).rjust_zero(2), ' - ', text].join)
        end
      end
    end
  end
end
