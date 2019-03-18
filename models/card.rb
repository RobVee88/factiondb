class Card < ActiveRecord::Base
    validates :user_id, presence: true
    validates :amount, presence: true
    validates :name, presence: true
    validates :edition, presence: true
    validates :image_url, presence: true
    belongs_to :user
end
