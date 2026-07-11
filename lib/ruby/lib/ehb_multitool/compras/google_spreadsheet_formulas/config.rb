# frozen_string_literal: true

module EhbMultitool
  module Compras
    module GoogleSpreadsheetFormulas
      module Config
        OFFER_OPTIONS = %w[Escolhido Comprado Recebido Concluído].freeze
        OFFER_STATES = StateList.from_texts 'Recebido', 'Escolhido', 'Comprado', 'Concluído',
                                            'Escolhido outro', 'Ativo', 'Inativo', 'Cancelado',
                                            'Indefinido'
        OFFERS_INTERVAL = 'Ofertas!$A:$H'
        OFFERS_ITEM_COLUMN = 'A'
        OFFERS_OPTION_COLUMN = 'B'
        OFFERS_ROW = 2

        ITEM_OPTIONS = %w[Cancelado Pausado Pesquisar].freeze
        ITEM_STATES = StateList.from_texts 'Recebido', 'Escolhido', 'Orçado', 'Orçar',
                                           'Selecionado', 'Pesquisar', 'Comprado', 'Pausado',
                                           'Concluído', 'Cancelado', 'Indefinido'
        ITEMS_INTERVAL = 'Itens!$A:$G'
        ITEMS_DESCRIPTION_COLUMN = 'C'

        ITEMS_OFFERS_COLUMN = 'E'
        ITEMS_OPTION_COLUMN = 'D'
        ITEMS_STATE_COLUMN = 'F'
        ITEMS_ROW = 2
      end
    end
  end
end
