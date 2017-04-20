require 'rails_helper'

RSpec.feature 'User reads category details', type: :feature do
  subject { page }

  let(:admin) { create :admin }
  let(:category) { create :category }

  before do
    create_list :course, 3, category: category
    visit category_path(category)
  end

  it 'should have link to courses from the category' do
    should have_link 'Wróć', href: categories_path
    should have_selector 'h1', text: category.name
    category.courses.each do |course|
      expect(page).to have_link course.name, href: course_path(course)
    end
  end

  context 'for admin' do
    before do
      login_as admin
      visit category_path(category)
    end

    it 'should have proper links' do
      should have_link 'Edytuj', href: edit_category_path(category)
      should have_link 'Usuń', href: category_path(category)
    end
  end
end
