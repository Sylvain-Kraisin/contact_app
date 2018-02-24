class User < ApplicationRecord
  has_and_belongs_to_many :tags

  validates :first_name, :last_name, :email, presence: true
  validates :email, uniqueness: true

  USERS_PER_PAGE = 10
end
