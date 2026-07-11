# frozen_string_literal: true

module EhbMultitool
  module Compras
    module GoogleSpreadsheetFormulas
      class Formula
        common_constructor :name, :arguments
        delegate :rstrip, to: :to_s

        # @return [String]
        def to_formula
          "=#{to_s.strip}\n"
        end

        # @return [String]
        def to_s
          "\n#{name.strip}( #{arguments.map { |e| e.to_s.rstrip }.join(' ; ')} )"
        end
      end
    end
  end
end
