# frozen_string_literal: true

module EhbMultitool
  module Compras
    module GoogleSpreadsheetFormulas
      class ItemStatus
        module Items
          include EhbMultitool::Compras::GoogleSpreadsheetFormulas::Config

          def comprar_agora_node
            iff("#{item_offers} >= 2", ITEM_STATES[:orcado].to_s, ITEM_STATES[:orcar].to_s)
          end

          def item_status_by_option(false_value)
            ITEM_OPTIONS[1..].inject(item_option_node(ITEM_OPTIONS.fetch(0), false_value)) do |a, e|
              item_option_node(e, a)
            end
          end

          def item_cell(column)
            "#{column}#{ITEMS_ROW}"
          end

          def item_offers
            item_cell(ITEMS_OFFERS_COLUMN)
          end

          def item_description
            item_cell(ITEMS_DESCRIPTION_COLUMN)
          end

          def item_option
            item_cell(ITEMS_OPTION_COLUMN)
          end

          def item_option_node(option, false_value, true_value = nil)
            state = ITEM_STATES.by_attribute(:text, option)
            if state.present?
              target_option = state.text_to_s
              true_value ||= state.to_s
            else
              target_option = "\"#{option}\""
              true_value ||= target_option
            end
            iff("#{item_option} = #{target_option}", true_value, false_value)
          end
        end
      end
    end
  end
end
