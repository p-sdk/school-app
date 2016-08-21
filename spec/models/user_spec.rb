# == Schema Information
#
# Table name: users
#
#  id              :integer          not null, primary key
#  name            :string
#  email           :string
#  password_digest :string
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  teacher         :boolean          default(FALSE)
#
# Indexes
#
#  index_users_on_email  (email) UNIQUE
#

require 'rails_helper'

RSpec.describe User, type: :model do
  subject(:user) { create :user }

  it { should_not be_teacher }

  describe 'validations' do
    it { should have_many(:teacher_courses).class_name('Course').with_foreign_key(:teacher_id).dependent(:destroy) }
    it { should have_many(:enrollments).with_foreign_key(:student_id).dependent(:destroy) }
    it { should have_many(:courses).through(:enrollments) }

    it { should validate_presence_of(:name) }
    it { should validate_length_of(:name). is_at_least(3). is_at_most(50) }

    it { should validate_presence_of(:email) }
    it { should validate_uniqueness_of(:email).case_insensitive }
    it { should validate_length_of(:email). is_at_least(5). is_at_most(100) }
    it { should allow_value('abc@def.gg').for(:email) }
    it { should_not allow_value('abcde').for(:email) }

    it { should validate_length_of(:password). is_at_least(5). is_at_most(60) }
    it { should validate_confirmation_of(:password) }
    it { should validate_presence_of(:password_confirmation) }
  end

  describe 'enrolling' do
    let(:enrolled_course) { create :course }
    let(:non_enrolled_course) { create :course }
    before { user.enroll_in enrolled_course }

    context 'for enrolled course' do
      it { should be_enrolled_in enrolled_course }
      specify { expect(subject.courses).to include enrolled_course }
      specify { expect(enrolled_course.students).to include user }
    end

    context 'for non-enrolled course' do
      it { should_not be_enrolled_in non_enrolled_course }
      specify { expect(subject.courses).not_to include non_enrolled_course }
      specify { expect(non_enrolled_course.students).not_to include user }
    end
  end

  describe '#admin?' do
    context 'for user with admin email' do
      before { user.update! email: 'admin@example.com' }
      it { should be_admin }
    end

    context 'otherwise' do
      it { should_not be_admin }
    end
  end

  describe '#request_upgrade' do
    it 'should be requesting upgrade' do
      expect { user.request_upgrade }.to change(user, :requesting_upgrade?).from(false).to(true)
    end
    it 'should not become teacher without approval' do
      expect { user.request_upgrade }.to_not change(user, :teacher?)
    end
  end

  describe '#requesting_upgrade?' do
    context 'when user requested upgrade' do
      before { user.request_upgrade }
      it { should be_requesting_upgrade }
    end

    context 'otherwise' do
      it { should_not be_requesting_upgrade }
    end
  end

  describe '#upgrade' do
    before { user.upgrade }
    specify { expect(user.requesting_upgrade?).to be false }
    specify { expect(user.teacher?).to be true }
  end

  describe '#downgrade' do
    before { user.downgrade }
    specify { expect(user.requesting_upgrade?).to be false }
    specify { expect(user.teacher?).to be false }
  end
end
