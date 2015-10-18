require 'rails_helper'

RSpec.feature 'Tasks', type: :feature do
  subject { page }
  let(:course) { create :course }

  describe 'index page' do
    before do
      sign_in_as course.teacher
      visit course_tasks_path(course)
    end

    it { should have_selector 'h1', text: course.name }
    it { should have_link 'Wróć', href: course_path(course) }
    it { should have_selector 'h2', text: 'Zadania' }

    context 'when there are some tasks' do
      let!(:tasks) { create_list :task, 3, course: course }
      before { visit course_tasks_path(course) }
      it 'should list course tasks' do
        tasks.each do |task|
          expect(page).to have_link task.title, href: course_task_path(course, task)
        end
      end
    end

    context 'when signed in as teacher' do
      it { should have_link 'Dodaj zadanie', href: new_course_task_path(course) }
    end

    context 'when signed in as student' do
      let!(:tasks) { create_list :task, 3, course: course }
      let(:enrollment) { create :enrollment, course: course }
      before { sign_in_as enrollment.student }

      describe 'show task statuses' do
        before do
          create :solution, enrollment: enrollment, task: tasks[0],
                            earned_points: rand(1..(tasks[0].points))
          create :solution, enrollment: enrollment, task: tasks[1]
          visit course_tasks_path(course)
        end
        it { should have_content "#{tasks[0].title} ocenione" }
        it { should have_content "#{tasks[1].title} czeka na sprawdzenie" }
        it { should have_content "#{tasks[2].title} nierozwiązane" }
      end

      describe 'show course grade' do
        let(:course_max_points) { tasks.map(&:points).sum }
        before { visit course_tasks_path(course) }

        it { should have_content 'Twój wynik' }
        it { should have_selector '.max-points', text: course_max_points }

        context 'with no tasks solved' do
          it { should have_selector '.earned-points', text: 0 }
        end

        context 'with solved tasks' do
          let(:solutions) do
            tasks.map do |t|
              create :solution, enrollment: enrollment, task: t,
                                earned_points: rand(1..(t.points))
            end
          end
          let!(:earned_points) { solutions.map(&:earned_points).sum }
          before { visit course_tasks_path(course) }
          it { should have_selector '.earned-points', text: earned_points }
        end
      end
    end
  end

  describe 'show page' do
    let(:task) { create :task, course: course }
    let(:enrollment) { create :enrollment, course: course }
    before do
      sign_in_as enrollment.student
      visit course_task_path(course, task)
    end

    it { should have_selector 'h1', text: course.name }
    it { should have_selector 'h2', text: task.title }
    it { should have_selector 'div.points', text: "Punktów do zdobycia: #{task.points}" }
    it { should have_selector 'div.desc', text: task.desc }
    it { should have_link 'Wróć', href: course_tasks_path(course) }

    context 'for enrolled student' do
      it { should_not have_link 'Edytuj' }
      it { should_not have_link 'Rozwiązania' }

      context 'with unsolved task' do
        it { should have_selector 'form.new_solution' }
        it { should_not have_link 'Moje rozwiązanie' }
      end

      context 'with solved task' do
        before do
          create :solution, enrollment: enrollment, task: task
          visit course_task_path(course, task)
        end
        it { should_not have_selector 'form.new_solution' }
        it { should have_link 'Moje rozwiązanie' }
      end
    end

    context 'for the teacher' do
      before do
        sign_in_as course.teacher
        visit course_task_path(course, task)
      end

      it { should have_link 'Edytuj', href: edit_course_task_path(course, task) }
      it { should have_link 'Rozwiązania', href: solutions_course_task_path(course, task) }
      it { should_not have_selector 'form.new_solution' }
      it { should_not have_link 'Moje rozwiązanie' }

      describe 'show average score' do
        let(:enrollments) { create_list :enrollment, 5, course: task.course }
        let(:solutions) do
          enrollments.map { |e| create :graded_solution, task: task, enrollment: e }
        end
        let!(:avg) { solutions.map(&:earned_points).sum / solutions.size }
        before { visit course_task_path(course, task) }
        it { should have_selector '.avg-score', text: "Przeciętny wynik: #{avg}" }
      end
    end
  end

  describe 'creating a task' do
    before do
      sign_in_as course.teacher
      visit new_course_task_path(course)
    end

    describe 'page' do
      it { should have_selector 'h1', text: course.name }
      it { should have_link 'Wróć', href: course_tasks_path(course) }
      it { should have_selector 'h2', text: 'Utwórz nowe zadanie' }
    end

    describe 'with invalid information' do
      it 'should not create a task' do
        expect { click_button 'Utwórz zadanie' }.not_to change(Task, :count)
      end

      describe 'after submission' do
        before { click_button 'Utwórz zadanie' }
        it { should have_selector 'h2', text: 'Utwórz nowe zadanie' }
        it { should have_error_message }
      end
    end

    describe 'with valid information' do
      let(:valid_task) { build :task }
      before do
        fill_in 'Tytuł', with: valid_task.title
        fill_in 'Opis', with: valid_task.desc
        fill_in 'Liczba punktów', with: valid_task.points
      end

      it 'should create a task' do
        expect { click_button 'Utwórz zadanie' }.to change(Task, :count).by(1)
      end

      describe 'after submission' do
        before { click_button 'Utwórz zadanie' }
        it { should have_selector 'h2', text: valid_task.title }
        it { should have_success_message }
      end
    end
  end

  describe 'editing the task' do
    let(:task) { create :task, course: course }
    before do
      sign_in_as course.teacher
      visit edit_course_task_path(course, task)
    end

    describe 'page' do
      it { should have_selector 'h1', text: course.name }
      it { should have_link 'Wróć', href: course_task_path(course, task) }
      it { should have_selector 'h2', text: 'Edytuj zadanie' }
    end

    context 'with invalid information' do
      before do
        fill_in 'Tytuł', with: ''
        click_button 'Zapisz zmiany'
      end
      it { should have_selector 'h2', text: 'Edytuj zadanie' }
      it { should have_error_message }
    end

    context 'with valid information' do
      let(:new_desc) { 'Officia deserunt mollit' }
      let(:new_points) { 60 }
      before do
        fill_in 'Opis', with: new_desc
        fill_in 'Liczba punktów', with: new_points
        click_button 'Zapisz zmiany'
      end
      it { should have_selector 'h2', text: task.title }
      it { should have_selector 'div.points', text: new_points }
      it { should have_selector 'div.desc', text: new_desc }
      it { should have_success_message }
    end
  end

  describe 'deleting task' do
    let(:task) { create :task, course: course }
    before do
      sign_in_as course.teacher
      visit edit_course_task_path(course, task)
    end

    it 'should delete the task' do
      expect { click_link 'Usuń' }.to change(Task, :count).by(-1)
    end

    context 'after deleting' do
      before { click_link 'Usuń' }
      it { expect(current_path).to eq course_tasks_path(course) }
      it { should have_success_message }
    end
  end

  describe 'solutions' do
    let(:task) { create :task, course: course }
    let(:enrollments) { create_list :enrollment, 3, course: course }
    before do
      sign_in_as course.teacher
      visit solutions_course_task_path(course, task)
    end

    it { should have_selector 'h1', text: course.name }
    it { should have_selector 'h2', text: task.title }
    it { should have_link 'Wróć', href: course_task_path(course, task) }

    it { should have_selector 'h3', text: 'Rozwiązania oczekujące na sprawdzenie' }
    describe 'list ungraded solutions' do
      let!(:ungraded_solutions) do
        enrollments.map { |e| create :solution, enrollment: e, task: task }
      end
      before { visit solutions_course_task_path(course, task) }
      specify do
        ungraded_solutions.each do |solution|
          expect(page).to have_link solution.student.name, href: edit_solution_path(solution)
        end
      end
    end

    it { should have_selector 'h3', text: 'Ocenione rozwiązania' }
    describe 'list graded solutions' do
      let!(:graded_solutions) do
        enrollments.map { |e| create :graded_solution, enrollment: e, task: task }
      end
      before { visit solutions_course_task_path(course, task) }
      specify do
        graded_solutions.each do |solution|
          expect(page).to have_link solution.student.name, href: solution_path(solution)
        end
      end
    end
  end
end
