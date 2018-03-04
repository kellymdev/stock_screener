require 'rails_helper'

RSpec.describe SharePrice, type: :model do
  describe 'validations' do
    let(:stock_exchange) { StockExchange.create!(name: 'ASX') }
    let(:stock) do
      stock_exchange.stocks.create!(
        company_name: 'Test Ltd',
        ticker_symbol: 'TST'
      )
    end
    let(:year) { Year.create!(year_number: 2018) }
    let(:high_value) { 1.00 }
    let(:low_value) { 0.50 }
    let(:share_price) do
      stock.share_prices.new(
        year: year,
        high_value: high_value,
        low_value: low_value
      )
    end

    context 'with valid details' do
      it 'is valid' do
        expect(share_price).to be_valid
      end
    end

    context 'with invalid details' do
      context 'when the stock already has a price for that year' do
        let!(:existing_stock_price) do
          stock.share_prices.create!(
            year: year,
            high_value: 1.50,
            low_value: 0.98
          )
        end

        it 'is invalid' do
          expect(share_price).not_to be_valid
        end
      end

      context 'when the stock does not have a high value' do
        let(:high_value) {}

        it 'is invalid' do
          expect(share_price).not_to be_valid
        end
      end

      context 'when the stock does not have a low value' do
        let(:low_value) {}

        it 'is invalid' do
          expect(share_price).not_to be_valid
        end
      end
    end
  end
end