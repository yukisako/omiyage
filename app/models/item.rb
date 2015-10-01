class Item < ActiveRecord::Base
  serialize :raw_info , Hash

  has_many :ownerships  , foreign_key: "item_id" , dependent: :destroy
  has_many :users , through: :ownerships
  has_many :wants, foreign_key: "item_id", class_name: "Want"
  has_many :want_users, through: :wants, source: :user, dependent: :destroy
  has_many :haves, foreign_key: "item_id", class_name: "Have"
  has_many :have_users, through: :haves, source: :user, dependent: :destroy
end
