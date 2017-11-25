require 'rails_helper'

RSpec.feature 'User reads lectures index', type: :feature do
  subject { page }

  let(:course) { create :course }
  let!(:lectures) { create_list :lecture, 3, course: course }
  let(:student) { create :student, course: course }

  before do
    sign_in student
    visit course_lectures_path(course)
  end

  it 'should list course lectures' do
    should have_selector 'h1', text: course.name
    should have_selector 'h2', text: 'Wykłady'
    should have_link 'Wróć', href: course_path(course)
    lectures.each do |lecture|
      expect(page).to have_link lecture.title, href: course_lecture_path(course, lecture)
    end
  end

  context 'for the teacher' do
    before do
      sign_in course.teacher
      visit course_lectures_path(course)
    end

    it { should have_link 'Dodaj wykład', href: new_course_lecture_path(course) }
  end
end
