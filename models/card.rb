class Card < ActiveRecord::Base
    validates :multiverse_id, presence: true
    validates :user_id, presence: true
    validates :amount, presence: true
    validates :name, presence: true
    validates :edition, presence: true
    validates :image_url, presence: true
end