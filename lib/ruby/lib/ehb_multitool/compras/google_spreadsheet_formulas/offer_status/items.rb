# frozen_string_literal: true

module EhbMultitool
  module Compras
    module GoogleSpreadsheetFormulas
      class OfferStatus
        module Items
          include EhbMultitool::Compras::GoogleSpreadsheetFormulas::Config

          def item_state_chain(state_result_values, final_false_value)
            return final_false_value if state_result_values.empty?

            state_result_values.shift.then do |s|
              iff("#{item_state} = #{ITEM_STATES[s.first]}", OFFER_STATES[s.last],
                  offer_option_chain(state_result_values, final_false_value))
            end
          end

          # @return [String]
          def item_state_equal(state_key, true_result, false_result)
            iff(ITEM_STATES[state_key].text_equal_to(item_state), true_result, false_result)
          end

          # @param state_result_values [Array<Array<Symbol, String>>]
          # @return [String]
          def item_state_equal_chain(state_result_values)
            state_result = state_result_values.unshift
            false_value = if state_result_values.any?
                            item_state_equal_chain(state_result_values)
                          else
                            'false'
                          end
            item_state_equal(state_result.first, state_result.last, false_value)
          end

          # @return [String]
          def item_state
            item_column(offer_item, ITEMS_STATE_COLUMN)
          end

          # @param item_description [String]
          # @param column [String]
          # @return [String]
          def item_column(item_description, column)
            formula('index',
                    formula('query', ITEMS_INTERVAL,
                            "\"select #{column} " \
                            "where #{ITEMS_DESCRIPTION_COLUMN} = '\" & #{item_description} & \"'\"",
                            'false'),
                    1, 1)
          end
        end
      end
    end
  end
end
