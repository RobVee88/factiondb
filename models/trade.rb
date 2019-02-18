class Trade < ActiveRecord::Base
    validates :user_id_owner, presence: true
    validates :user_id_borrower, presence: true
    validates :card_id, presence: true
    validates :amount, presence: true
end