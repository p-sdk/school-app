require 'rails_helper'

RSpec.feature 'Courses', type: :feature do
  subject { page }

  describe 'index page' do
    before do
      create_list :course, 6
      visit courses_path
    end

    it 'should display all courses' do
      should have_selector 'h1', text: 'Kursy'
      should have_link 'Przeglądaj wg kategorii', href: categories_path
      Course.all.each do |course|
        expect(page).to have_link course.name, href: course_path(course)
      end
    end
  end

  describe 'show page' do
    let(:course) { create :course }
    before { visit course_path(course) }

    it 'should display the course' do
      should have_selector 'h1', text: course.name
      should have_selector 'div.teacher i', text: course.teacher.name
      should have_selector 'div.desc', text: course.desc
    end

    context 'when not signed in' do
      it 'should have proper links' do
        should_not have_button 'Zapisz się'
        should_not have_link 'Edytuj', href: edit_course_path(course)
        should_not have_link 'Zapisani studenci', href: students_course_path(course)
        should_not have_link 'Wykłady', href: course_lectures_path(course)
        should_not have_link 'Zadania', href: course_tasks_path(course)
      end
    end

    context 'for the teacher' do
      before do
        sign_in_as course.teacher
        visit course_path(course)
      end

      it 'should have proper links' do
        should_not have_button 'Zapisz się'
        should have_link 'Edytuj', href: edit_course_path(course)
        should have_link 'Zapisani studenci', href: students_course_path(course)
        should have_link 'Wykłady', href: course_lectures_path(course)
        should have_link 'Zadania', href: course_tasks_path(course)
      end
    end

    context 'for students' do
      let(:student) { create :user }
      before do
        sign_in_as student
        visit course_path(course)
      end

      it { should_not have_link 'Edytuj', href: edit_course_path(course) }

      context 'when enrolled' do
        before do
          student.enroll_in(course)
          visit course_path(course)
        end

        it 'should have proper links' do
          should_not have_button 'Zapisz się'
          should_not have_link 'Zapisani studenci', href: students_course_path(course)
          should have_link 'Wykłady', href: course_lectures_path(course)
          should have_link 'Zadania', href: course_tasks_path(course)
        end
      end

      context 'when not enrolled' do
        it 'should have proper links' do
          should have_button 'Zapisz się'
          should_not have_link 'Zapisani studenci', href: students_course_path(course)
          should_not have_link 'Wykłady', href: course_lectures_path(course)
          should_not have_link 'Zadania', href: course_tasks_path(course)
        end

        describe 'enrollment' do
          specify do
            expect do
              click_button 'Zapisz się'
            end.to change(student.courses, :count).by(1)
          end
          specify do
            expect do
              click_button 'Zapisz się'
            end.to change(course.students, :count).by(1)
          end
          describe 'after submission' do
            before { click_button 'Zapisz się' }
            it { should_not have_button 'Zapisz się' }
          end
        end
      end
    end
  end

  describe 'creating new course' do
    let(:teacher) { create :teacher }
    before do
      sign_in_as teacher
      visit new_course_path
    end

    describe 'page' do
      it do
        should have_selector 'h1', text: 'Utwórz nowy kurs'
        should have_link 'Wróć', href: root_path
      end
    end

    context 'with invalid information' do
      it 'should not create a course' do
        expect { click_button 'Utwórz kurs' }.to_not change(Course, :count)
      end

      describe 'after submission' do
        before { click_button 'Utwórz kurs' }
        it 'should display error message' do
          should have_selector 'h1', text: 'Utwórz nowy kurs'
          should have_error_message
        end
      end
    end

    context 'with valid information' do
      let!(:category) { create :category }
      let(:valid_course) { build :course, category: category }
      before do
        visit new_course_path
        fill_in 'Nazwa', with: valid_course.name
        fill_in 'Opis', with: valid_course.desc
        select valid_course.category.name, from: 'Kategoria'
      end

      it 'should create a course' do
        expect { click_button 'Utwórz kurs' }.to change(Course, :count).by(1)
      end

      describe 'after submission' do
        before { click_button 'Utwórz kurs' }
        it 'should display success message' do
          should have_selector 'h1', text: valid_course.name
          should have_success_message
        end
      end
    end
  end

  describe 'editing course' do
    let(:course) { create :course }
    before do
      sign_in_as course.teacher
      visit edit_course_path(course)
    end

    describe 'page' do
      it do
        should have_selector 'h1', text: 'Edytuj kurs'
        should have_link 'Wróć', href: course_path(course)
      end
    end

    context 'with invalid information' do
      before do
        fill_in 'Nazwa', with: ''
        click_button 'Zapisz zmiany'
      end
      it 'should display error message' do
        should have_selector 'h1', text: 'Edytuj kurs'
        should have_error_message
      end
    end

    context 'with valid information' do
      let(:new_desc) { 'Sunt in culpa qui officia deserunt mollit anim id est laborum.' }
      before do
        fill_in 'Opis', with: new_desc
        click_button 'Zapisz zmiany'
      end

      it 'should display success message' do
        should have_selector 'h1', text: course.name
        should have_selector 'div.desc', text: new_desc
        should have_success_message
      end
    end
  end

  describe 'deleting course' do
    let(:course) { create :course }
    before do
      sign_in_as course.teacher
      visit edit_course_path(course)
    end

    it 'should delete the course' do
      expect { click_link 'Usuń' }.to change(Course, :count).by(-1)
    end

    context 'after deleting' do
      before { click_link 'Usuń' }
      it 'should display success message' do
        expect(current_path).to eq courses_path
        should have_success_message
      end
    end
  end

  describe 'students' do
    let(:course) { create :course }
    let(:students) { create_list :user, 3 }
    before do
      students.each { |s| s.enroll_in course }
      sign_in_as course.teacher
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
end
