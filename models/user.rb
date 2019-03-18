class User < ActiveRecord::Base
    has_secure_password
    validates :user_name, presence: true
    validates :password, presence: true
    validates :email, presence: true
    has_many :cards
end

