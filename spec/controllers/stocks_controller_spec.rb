require 'rails_helper'

RSpec.describe StocksController, type: :controller do
  render_views

  let!(:stock_exchange) { StockExchange.create!(name: 'ASX') }
  let!(:stock) do
    stock_exchange.stocks.create!(
      company_name: 'Existing Stock',
      ticker_symbol: 'EXT'
    )
  end

  describe '#new' do
    it 'returns http status 200' do
      get :new, params: { stock_exchange_id: stock_exchange.id }

      expect(response.status).to eq 200
    end
  end

  describe '#create' do
    let(:company_name) { 'Test Ltd' }
    let(:ticker_symbol) { 'TST' }
    let(:stock_params) do
      {
        stock_exchange_id: stock_exchange.id,
        stock: {
          company_name: company_name,
          ticker_symbol: ticker_symbol
        }
      }
    end

    context 'with valid params' do
      it 'creates a new stock' do
        expect { post :create, params: stock_params }.to change { Stock.count }.by 1
      end
    end

    context 'with invalid params' do
      let(:company_name) { 'Test' }

      it 'does not create a new stock' do
        expect { post :create, params: stock_params }.to change { Stock.count }.by 0
      end
    end
  end

  describe '#show' do
    it 'returns http status 200' do
      get :show, params: { id: stock.id }

      expect(response.status).to eq 200
    end
  end

  describe '#edit' do
    it 'returns http status 200' do
      get :edit, params: { id: stock.id }

      expect(response.status).to eq 200
    end
  end

  describe '#update' do
    let(:company_name) { 'Test Ltd' }
    let(:ticker_symbol) { 'TST' }
    let(:stock_params) do
      {
        id: stock.id,
        stock: {
          company_name: company_name,
          ticker_symbol: ticker_symbol
        }
      }
    end

    context 'with valid params' do
      it 'updates the stock' do
        put :update, params: stock_params

        expect(stock.reload.company_name).to eq company_name
      end
    end

    context 'with invalid params' do
      let(:company_name) { 'Test' }

      it 'does not update the stock' do
        put :update, params: stock_params

        expect(stock.reload.company_name).to eq 'Existing Stock'
      end
    end
  end

  describe '#new_report' do
    it 'returns http status 200' do
      get :new_report, params: { stock_id: stock.id }

      expect(response.status).to eq 200
    end
  end

  describe '#report' do
    let(:current_price) { '4.00' }
    let(:government_bond_interest_rate) { '3.0' }
    let(:report_params) do
      ActionController::Parameters.new(current_price: current_price, government_bond_interest_rate: government_bond_interest_rate).permit(:current_price, :government_bond_interest_rate)
    end

    it 'returns http status 200' do
      post :report, params: { stock_id: stock.id, current_price: current_price, government_bond_interest_rate: government_bond_interest_rate }

      expect(response.status).to eq 200
    end

    it 'generates a stock report' do
      expect(GenerateStockReport).to receive(:new).with(stock, report_params).and_call_original

      post :report, params: { stock_id: stock.id, current_price: current_price, government_bond_interest_rate: government_bond_interest_rate }
    end
  end
end
