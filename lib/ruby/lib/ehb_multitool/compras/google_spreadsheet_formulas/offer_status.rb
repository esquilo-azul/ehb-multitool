# frozen_string_literal: true

module EhbMultitool
  module Compras
    module GoogleSpreadsheetFormulas
      class OfferStatus
        include ::EhbMultitool::Compras::GoogleSpreadsheetFormulas::BaseStatus
        include EhbMultitool::Compras::GoogleSpreadsheetFormulas::Config

        # @return [String]
        def root
          by_offer_option(by_escolhido_outro(OFFER_STATES[:indefinido]))
        end

        protected

        def by_escolhido_outro(false_value)
          iff(
            formula(
              'not',
              formula('isna',
                      formula('match', item_state, items_for_escolhido_outro, 0))
            ), OFFER_STATES[:escolhido_outro], false_value
          )
        end

        def by_offer_option(false_value)
          offer_option_chain(%i[recebido escolhido comprado concluido ativo inativo cancelado],
                             false_value)
        end

        def items_for_escolhido_outro
          [
            '{',
            %i[concluido comprado recebido escolhido].map { |k| ITEM_STATES[k] }.join('; '),
            '}'
          ].join
        end

        require_sub __FILE__, include_modules: true
      end
    end
  end
end
