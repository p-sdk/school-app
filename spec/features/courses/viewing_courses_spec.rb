require 'rails_helper'

RSpec.feature 'User reads courses index', type: :feature do
  subject { page }

  before do
    create_list :course, 6
    visit courses_path
  end

  it 'should display all courses' do
    should have_heading 'Kursy'
    should have_link 'Przeglądaj wg kategorii', href: categories_path
    Course.all.each do |course|
      expect(page).to have_link course.name, href: course_path(course)
    end
  end
end
