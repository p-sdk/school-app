# == Schema Information
#
# Table name: categories
#
#  id   :integer          not null, primary key
#  name :string
#

FactoryBot.define do
  factory :category do
    sequence(:name) { |n| "Category #{n}" }
  end
end
