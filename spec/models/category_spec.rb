# == Schema Information
#
# Table name: categories
#
#  id   :bigint           not null, primary key
#  name :string
#

require 'rails_helper'

RSpec.describe Category do
  subject(:category) { build :category }

  describe 'validations' do
    it { should have_many(:courses).dependent(:destroy) }

    it { should validate_presence_of(:name) }
    it { should validate_uniqueness_of(:name) }
    it { should validate_length_of(:name).is_at_least(3).is_at_most(100) }
  end
end
