class Downloaded_card < ActiveRecord::Base
    validates :name, presence: true
    validates :edition, presence: true
    validates :image_url, presence: true
end