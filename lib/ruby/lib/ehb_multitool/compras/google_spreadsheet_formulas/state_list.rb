# frozen_string_literal: true

module EhbMultitool
  module Compras
    module GoogleSpreadsheetFormulas
      class StateList < ::EacRubyUtils::ObjectsTable
        class << self
          # @param texts [Enumerable<String>]
          # @return [EacRubyUtils::ObjectsTable]
          def from_texts(*texts)
            new(texts.each_with_index.map { |e, i| State.new(i, e) })
          end
        end

        # @param key [Symbol]
        # @return [EhbMultitool::Compras::GoogleSpreadsheetFormulas::State]
        def [](key)
          by_attribute!(:key, key)
        end
      end
    end
  end
end
