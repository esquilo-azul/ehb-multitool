# frozen_string_literal: true

RSpec.describe EhbMultitool::Compras::GoogleSpreadsheetFormulas::IfNode do
  let(:instance) { described_class.new('CONDITION', 'TRUE_VALUE', 'FALSE_VALUE') }

  it do
    expect(instance.to_s).to eq("\nif( CONDITION ; TRUE_VALUE ; FALSE_VALUE )")
  end
end
