# frozen_string_literal: true

module EhbMultitool
  module Compras
    module GoogleSpreadsheetFormulas
      class ItemStatus
        include ::EhbMultitool::Compras::GoogleSpreadsheetFormulas::BaseStatus

        def root
          offer_statuses_node(
            item_status_by_option(
              item_option_node(
                'Comprar logo',
                item_option_node('Comprar agora', 'FALSE', comprar_agora_node),
                ITEM_STATES[:selecionado]
              )
            )
          )
        end

        require_sub __FILE__, include_modules: true
      end
    end
  end
end
