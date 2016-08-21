# == Schema Information
#
# Table name: categories
#
#  id   :integer          not null, primary key
#  name :string
#

class Category < ActiveRecord::Base
  has_many :courses, dependent: :destroy

  validates :name,
            presence: true,
            uniqueness: true,
            length: { in: 3..100 }
end
