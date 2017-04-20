require 'rails_helper'

RSpec.feature 'User reads categories index', type: :feature do
  subject { page }

  let(:admin) { create :admin }
  let(:cat1) { create :category }
  let(:cat2) { create :category }

  before do
    create_list :course, 3, category: cat1
    create_list :course, 2, category: cat2
    visit categories_path
  end

  it 'should display all categories' do
    should have_link 'Wróć', href: courses_path
    should have_content "#{cat1.name} ( #{cat1.courses.size} )"
    should have_content "#{cat2.name} ( #{cat2.courses.size} )"
    should have_link cat1.name, href: category_path(cat1)
    should have_link cat2.name, href: category_path(cat2)
  end

  context 'for admin' do
    before do
      login_as admin
      visit categories_path
    end
    it { should have_link 'Dodaj nową kategorię', href: new_category_path }
  end
end
