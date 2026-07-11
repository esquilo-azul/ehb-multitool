# frozen_string_literal: true

module EhbMultitool
  module Compras
    module GoogleSpreadsheetFormulas
      class OfferStatus
        module Offers
          include EhbMultitool::Compras::GoogleSpreadsheetFormulas::Config

          def offer_option_chain(state_keys, final_false_value)
            return final_false_value if state_keys.empty?

            OFFER_STATES[state_keys.shift].then do |s|
              iff("#{offer_option} = #{s.text_to_s}", s,
                  offer_option_chain(state_keys, final_false_value))
            end
          end

          # @param column [Integer]
          # @return [String]
          def offer_cell(column)
            "#{column}#{OFFERS_ROW}"
          end

          # @return [String]
          def offer_item
            offer_cell(OFFERS_ITEM_COLUMN)
          end

          # @return [String]
          def offer_option
            offer_cell(OFFERS_OPTION_COLUMN)
          end
        end
      end
    end
  end
end
