require 'rails_helper'

RSpec.feature 'Lectures', type: :feature do
  subject { page }
  let(:course) { create :course }

  describe 'index page' do
    let(:student) { create :user }
    let!(:lectures) { create_list :lecture, 3, course: course }
    before do
      student.enroll_in course
      sign_in_as student
      visit course_lectures_path(course)
    end

    it { should have_selector 'h1', text: course.name }
    it { should have_link 'Wróć', href: course_path(course) }
    it { should have_selector 'h2', text: 'Wykłady' }
    it 'should list course lectures' do
      lectures.each do |lecture|
        expect(page).to have_link lecture.title, href: course_lecture_path(course, lecture)
      end
    end

    context 'for the teacher' do
      before do
        sign_in_as course.teacher
        visit course_lectures_path(course)
      end
      it { should have_link 'Dodaj wykład', href: new_course_lecture_path(course) }
    end
  end

  describe 'show page' do
    let(:student) { create :user }
    let(:lecture) { create :lecture, course: course }
    before do
      student.enroll_in course
      sign_in_as student
      visit course_lecture_path(course, lecture)
    end

    it { should have_selector 'h1', text: course.name }
    it { should have_selector 'h2', text: lecture.title }
    it { should have_link 'Wróć', href: course_lectures_path(course) }
    it { should have_selector 'div.lecture', text: lecture.content }

    context 'for the teacher' do
      before do
        sign_in_as course.teacher
        visit course_lecture_path(course, lecture)
      end
      it { should have_link 'Edytuj', href: edit_course_lecture_path(course, lecture) }
    end
  end

  describe 'creating a lecture' do
    before do
      sign_in_as course.teacher
      visit new_course_lecture_path(course)
    end

    describe 'page' do
      it { should have_selector 'h1', text: course.name }
      it { should have_link 'Wróć', href: course_lectures_path(course) }
      it { should have_selector 'h2', text: 'Utwórz nowy wykład' }
    end

    describe 'with invalid information' do
      it 'should not create a lecture' do
        expect { click_button 'Utwórz wykład' }.not_to change(Lecture, :count)
      end

      describe 'after submission' do
        before { click_button 'Utwórz wykład' }
        it { should have_selector 'h2', text: 'Utwórz nowy wykład' }
        it { should have_error_message }
      end
    end

    describe 'with valid information' do
      let(:valid_lecture) { build :lecture }
      before do
        fill_in 'Tytuł', with: valid_lecture.title
        fill_in 'Treść', with: valid_lecture.content
      end

      it 'should create a lecture' do
        expect { click_button 'Utwórz wykład' }.to change(Lecture, :count).by(1)
      end

      describe 'after submission' do
        before { click_button 'Utwórz wykład' }
        it { should have_selector 'h2', text: valid_lecture.title }
        it { should have_success_message }
      end
    end
  end

  describe 'editing the lecture' do
    let(:lecture) { create :lecture, course: course }
    before do
      sign_in_as course.teacher
      visit edit_course_lecture_path(course, lecture)
    end

    describe 'page' do
      it { should have_selector 'h1', text: course.name }
      it { should have_selector 'h2', text: 'Edytuj wykład' }
      it { should have_link 'Wróć', href: course_lecture_path(course, lecture) }
    end

    context 'with invalid information' do
      before do
        fill_in 'Tytuł', with: ''
        click_button 'Zapisz zmiany'
      end
      it { should have_selector 'h2', text: 'Edytuj wykład' }
      it { should have_error_message }
    end

    context 'with valid information' do
      let(:new_content) { 'Officia deserunt mollit' }
      before do
        fill_in 'Treść', with: new_content
        click_button 'Zapisz zmiany'
      end
      it { should have_selector 'h2', text: lecture.title }
      it { should have_selector 'div.lecture', text: new_content }
      it { should have_success_message }
    end
  end

  describe 'deleting lecture' do
    let(:lecture) { create :lecture, course: course }
    before do
      sign_in_as course.teacher
      visit edit_course_lecture_path(course, lecture)
    end

    it 'should delete the lecture' do
      expect { click_link 'Usuń' }.to change(Lecture, :count).by(-1)
    end

    context 'after deleting' do
      before { click_link 'Usuń' }
      it { expect(current_path).to eq course_lectures_path(course) }
      it { should have_success_message }
    end
  end
end
