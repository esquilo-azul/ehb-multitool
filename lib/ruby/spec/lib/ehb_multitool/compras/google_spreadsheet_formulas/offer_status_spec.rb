# frozen_string_literal: true

RSpec.describe EhbMultitool::Compras::GoogleSpreadsheetFormulas::OfferStatus do
  include_examples 'source_target_fixtures', __FILE__

  def source_data(_source_file)
    EhbMultitool::Compras::GoogleSpreadsheetFormulas::OfferStatus.new.result
  end

  def target_content(data)
    data
  end

  def target_data(target_file)
    target_file.to_pathname.read
  end

  def target_file_extname
    ''
  end
end
