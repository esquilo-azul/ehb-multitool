# frozen_string_literal: true

module EhbMultitool
  module Compras
    module GoogleSpreadsheetFormulas
      class IfNode < Formula
        def initialize(condition, true_value, false_value)
          super('if', [condition, true_value, false_value])
        end
      end
    end
  end
end
