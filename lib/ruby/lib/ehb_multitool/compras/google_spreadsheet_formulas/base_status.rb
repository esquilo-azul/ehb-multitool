# frozen_string_literal: true

module EhbMultitool
  module Compras
    module GoogleSpreadsheetFormulas
      module BaseStatus
        common_concern do
          acts_as_abstract :root
        end

        # @param name [String]
        # @param arguments [Enumerable<String>]
        # @return [EhbMultitool::Compras::GoogleSpreadsheetFormulas::Formula]
        def formula(name, *arguments)
          ::EhbMultitool::Compras::GoogleSpreadsheetFormulas::Formula.new(name, arguments)
        end

        # @return [EhbMultitool::Compras::GoogleSpreadsheetFormulas::IfNode]
        def iff(*)
          ::EhbMultitool::Compras::GoogleSpreadsheetFormulas::IfNode.new(*)
        end

        # @return [String]
        def result
          root.to_formula
        end
      end
    end
  end
end
