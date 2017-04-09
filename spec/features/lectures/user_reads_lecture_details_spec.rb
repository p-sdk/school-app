require 'rails_helper'

RSpec.feature 'User reads lecture details', type: :feature do
  subject { page }

  let(:course) { create :course }
  let(:student) { create :user }
  let(:lecture) { create :lecture, course: course }

  before do
    student.enroll_in course
    sign_in_as student
    visit course_lecture_path(course, lecture)
  end

  it 'should display the lecture' do
    should have_selector 'h1', text: course.name
    should have_selector 'h2', text: lecture.title
    should have_link 'Wróć', href: course_lectures_path(course)
    should have_selector 'div.lecture', text: lecture.content
  end

  context 'for the teacher' do
    before do
      sign_in_as course.teacher
      visit course_lecture_path(course, lecture)
    end
    it { should have_link 'Edytuj', href: edit_course_lecture_path(course, lecture) }
  end
end
