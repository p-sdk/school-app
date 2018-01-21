require 'rails_helper'

RSpec.feature 'User views lectures', type: :feature do
  subject { page }

  let(:course) { create :course }
  let!(:lectures) { create_list :lecture, 3, course: course }
  let(:lecture) { lectures.first }
  let(:student) { create :student, course: course }
  let(:user) { student }

  background do
    sign_in user
    visit course_path(course)
    click_link 'Wykłady'
  end

  scenario 'successfully' do
    should have_heading course.name
    should have_heading 'Wykłady'
    should have_link course.name, href: course_path(course)
    lectures.each do |lecture|
      expect(page).to have_link lecture.title, href: course_lecture_path(course, lecture)
    end

    click_link lecture.title

    should have_heading course.name
    should have_heading lecture.title
    should have_link 'Wykłady', href: course_lectures_path(course)
    should have_selector 'div.lecture', text: lecture.content
  end
end
