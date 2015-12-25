require 'rails_helper'

RSpec.feature 'Users', type: :feature do
  subject { page }

  describe 'index' do
    let(:admin) { create :admin }
    let!(:students) { create_list :user, 2 }
    let!(:teachers) { create_list :teacher, 2 }
    let!(:requesting_upgrade_users) { create_list :teacher, 2, teacher: nil }
    before do
      sign_in_as admin
      visit users_path
    end

    it { should have_selector 'h1', text: 'Użytkownicy' }
    it 'should list all users requesting upgrade' do
      requesting_upgrade_users.each do |user|
        expect(page).to have_link user.name, href: user_path(user)
      end
    end
    it 'should list all teachers' do
      teachers.each do |teacher|
        expect(page).to have_link teacher.name, href: user_path(teacher)
      end
    end
    it 'should list all students' do
      students.each do |student|
        expect(page).to have_link student.name, href: user_path(student)
      end
    end
  end

  describe 'profile page' do
    let(:user) { create :user }
    before { visit user_path(user) }

    it 'should display the user' do
      should have_selector 'h1', text: user.name
      should have_link user.email
      should have_selector 'div#avatar img.gravatar'
    end

    describe 'teacher' do
      let(:teacher) { create :teacher }
      before do
        create_list :course, 3, teacher: teacher
        visit user_path(teacher)
      end
      it 'should list owned courses' do
        teacher.teacher_courses.each do |course|
          expect(page).to have_link course.name, href: course_path(course)
        end
      end
    end

    context 'when the user sent upgrade request' do
      before { user.request_upgrade }
      context 'when signed in as admin' do
        let(:admin) { create :admin }
        before do
          sign_in_as admin
          visit user_path(user)
        end
        it 'should display proper links' do
          should have_link 'Wróć', users_path
          should have_link 'Zatwierdź'
          should have_link 'Odrzuć'
        end
      end
    end
  end

  describe 'signup' do
    before { visit signup_path }

    describe 'page' do
      it { should have_selector 'h1', text: 'Rejestracja' }
    end

    context 'with invalid information' do
      it 'should not create a user' do
        expect { click_button 'Załóż konto' }.not_to change(User, :count)
      end

      describe 'after submission' do
        before { click_button 'Załóż konto' }
        it 'should display error message' do
          should have_selector 'h1', text: 'Rejestracja'
          should have_error_message
        end
      end
    end

    context 'with valid information' do
      let(:valid_user) { build :user }
      before do
        fill_in 'Imię i nazwisko', with: valid_user.name
        fill_in 'Email', with: valid_user.email
        fill_in 'Hasło', with: valid_user.password
        fill_in 'Potwierdzenie hasła', with: valid_user.password_confirmation
      end

      it 'should create a user' do
        expect { click_button 'Załóż konto' }.to change(User, :count).by(1)
      end

      describe 'after submission' do
        before { click_button 'Załóż konto' }
        it 'should display success message' do
          should have_link 'Przeglądaj kursy', href: courses_path
          should have_link 'Wyloguj'
          should have_success_message
        end
      end
    end
  end

  describe 'edit' do
    let(:user) { create :user }
    before do
      sign_in_as user
      visit edit_user_path(user)
    end

    describe 'page' do
      it do
        should have_selector 'h1', text: 'Edytuj mój profil'
        should have_link 'rozszerzenie'
      end
    end

    context 'with invalid information' do
      before { click_button 'Zapisz zmiany' }
      it 'should display error message' do
        should have_selector 'h1', text: 'Edytuj mój profil'
        should have_error_message
      end
    end

    context 'with valid information' do
      let(:new_name) { 'New name' }
      let(:new_email) { 'new@example.com' }
      before do
        fill_in 'Imię i nazwisko', with: new_name
        fill_in 'Email', with: new_email
        fill_in 'Hasło', with: user.password
        fill_in 'Potwierdzenie hasła', with: user.password
        click_button 'Zapisz zmiany'
      end

      it 'should display success message' do
        should have_selector 'h1', text: new_name
        should have_selector 'div.email', text: new_email
        should have_link 'Wyloguj', href: signout_path
        should have_success_message
      end
    end

    describe 'submitting request to upgrade to teacher account' do
      before { click_on 'rozszerzenie' }
      it 'should be waiting for approval' do
        expect(User.requesting_upgrade).to include user
        expect(user.reload).to be_requesting_upgrade
        should have_success_message
      end
      describe 'edit page' do
        before { visit edit_user_path(user) }
        it 'should have proper message' do
          should_not have_link 'rozszerzenie'
          should have_content 'czeka na akceptację'
        end
      end
    end
  end

  describe 'deleting user' do
    let(:user) { create :user }
    before do
      sign_in_as user
      visit edit_user_path(user)
    end

    it 'should delete the user' do
      expect { click_link 'Usuń' }.to change(User, :count).by(-1)
    end

    context 'after deleting' do
      before { click_link 'Usuń' }
      it 'should display success message' do
        expect(current_path).to eq signup_path
        should have_success_message
      end
    end
  end

  describe 'upgrade' do
    let(:user) { create :user }
    let(:admin) { create :admin }
    before do
      user.request_upgrade
      sign_in_as admin
      visit user_path(user)
    end
    context 'after approving' do
      before { click_on 'Zatwierdź' }
      it 'should upgrade the user' do
        expect(User.requesting_upgrade).not_to include user
        expect(user.reload).to be_teacher
        should have_success_message
      end
    end

    context 'after dismissing' do
      before { click_on 'Odrzuć' }
      it 'should not upgrade the user' do
        expect(User.requesting_upgrade).not_to include user
        expect(user.reload).not_to be_teacher
        should have_success_message
      end
    end
  end
end
