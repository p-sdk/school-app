require 'rails_helper'

RSpec.feature 'User reads lecture details', type: :feature do
  subject { page }

  let(:lecture) { create :lecture }
  let(:course) { lecture.course }
  let(:student) { create :student, course: course }
  let(:user) { student }

  before do
    sign_in user
    visit course_lecture_path(course, lecture)
  end

  it 'should display the lecture' do
    should have_heading course.name
    should have_heading lecture.title
    should have_link 'Wróć', href: course_lectures_path(course)
    should have_selector 'div.lecture', text: lecture.content
  end

  context 'for the teacher' do
    let(:user) { course.teacher }

    it { should have_link 'Edytuj', href: edit_course_lecture_path(course, lecture) }
  end
end
