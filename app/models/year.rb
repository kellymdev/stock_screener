class Year < ApplicationRecord
  has_many :share_prices, dependent: :destroy

  validates :year_number, presence: true, length: { is: 4, message: 'must be between 1000 and 9999' }
end
