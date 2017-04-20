require 'rails_helper'

RSpec.feature 'User reads course students', type: :feature do
  subject { page }

  let(:course) { create :course }
  let(:students) { create_list :user, 3 }

  before do
    students.each { |s| s.enroll_in course }
    login_as course.teacher
    visit students_course_path(course)
  end

  it 'should list all students enrolled to the course' do
    should have_selector 'h1', text: course.name
    should have_link 'Wróć', href: course_path(course)
    should have_selector 'h2', text: 'Zapisani studenci'
    students.each do |student|
      expect(page).to have_link student.name, href: user_path(student)
    end
  end
end
