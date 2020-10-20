class Album < ApplicationRecord
  has_and_belongs_to_many :tags
  has_many :songs
  has_one :user
end
