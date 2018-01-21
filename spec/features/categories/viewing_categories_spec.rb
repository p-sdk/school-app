require 'rails_helper'

RSpec.feature 'User views categories', type: :feature do
  subject { page }

  let(:cat1) { create :category }
  let(:cat2) { create :category }

  background do
    create_list :course, 3, category: cat1
    create_list :course, 2, category: cat2
    visit courses_path
    click_link 'Przeglądaj wg kategorii'
  end

  scenario 'successfully' do
    should have_content "#{cat1.name} ( #{cat1.courses.size} )"
    should have_content "#{cat2.name} ( #{cat2.courses.size} )"
    should have_link cat1.name, href: category_path(cat1)
    should have_link cat2.name, href: category_path(cat2)

    click_link cat1.name

    should have_link 'Kategorie', href: categories_path
    should have_heading cat1.name
    cat1.courses.each do |course|
      expect(page).to have_link course.name, href: course_path(course)
    end
  end
end
