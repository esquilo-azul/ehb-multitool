# frozen_string_literal: true

module EhbMultitool
  module Compras
    module GoogleSpreadsheetFormulas
      class ItemStatus
        module Offers
          include EhbMultitool::Compras::GoogleSpreadsheetFormulas::Config

          def offer_statuses_node(false_value)
            OFFER_OPTIONS[1..].inject(offer_status_node(OFFER_OPTIONS.fetch(0),
                                                        false_value)) do |a, e|
              offer_status_node(e, a)
            end
          end

          def offer_status_node(status, false_value)
            iff("#{offers_status_count(status)} > 0", ITEM_STATES.by_text!(status), false_value)
          end

          def offers_value_count(column, value)
            "countif(query(#{OFFERS_INTERVAL}; " \
              "\"select #{column} " \
              "where #{OFFERS_ITEM_COLUMN} = '\" & #{item_description} & \"'\"); " \
              "\"#{value}\")"
          end

          def offers_status_count(status)
            offers_value_count(OFFERS_OPTION_COLUMN, status)
          end
        end
      end
    end
  end
end
