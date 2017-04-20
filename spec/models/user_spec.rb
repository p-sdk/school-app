# == Schema Information
#
# Table name: users
#
#  id                      :integer          not null, primary key
#  name                    :string
#  email                   :string
#  password_digest         :string
#  created_at              :datetime         not null
#  updated_at              :datetime         not null
#  upgrade_request_sent_at :datetime
#  encrypted_password      :string           default(""), not null
#  reset_password_token    :string
#  reset_password_sent_at  :datetime
#  remember_created_at     :datetime
#  sign_in_count           :integer          default(0), not null
#  current_sign_in_at      :datetime
#  last_sign_in_at         :datetime
#  current_sign_in_ip      :inet
#  last_sign_in_ip         :inet
#  role                    :integer          default(0)
#
# Indexes
#
#  index_users_on_email                 (email) UNIQUE
#  index_users_on_reset_password_token  (reset_password_token) UNIQUE
#

require 'rails_helper'

RSpec.describe User, type: :model do
  subject(:user) { build :user }

  it { should_not be_teacher }

  describe 'validations' do
    it { should have_many(:teacher_courses).class_name('Course').with_foreign_key(:teacher_id).dependent(:destroy) }
    it { should have_many(:enrollments).with_foreign_key(:student_id).dependent(:destroy) }
    it { should have_many(:courses).through(:enrollments) }

    it { should validate_presence_of(:name) }
    it { should validate_length_of(:name). is_at_least(3). is_at_most(50) }
  end

  describe '.requesting_upgrade' do
    subject { described_class.requesting_upgrade }

    let!(:alice) { create :user }
    let!(:bob) { create :user }

    before do
      alice.request_upgrade
    end

    it { is_expected.to include alice }
    it { is_expected.to_not include bob }
  end

  describe 'enrolling' do
    let!(:enrolled_course) { create :course }
    let!(:non_enrolled_course) { create :course }

    before do
      user.save
      user.enroll_in enrolled_course
    end

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

  describe '#approve_upgrade_request' do
    subject { user.approve_upgrade_request }

    before { user.request_upgrade }

    specify do
      expect { subject }.to change(user, :requesting_upgrade?).from(true).to(false)
    end

    specify do
      expect { subject }.to change(user, :teacher?).from(false).to(true)
    end
  end

  describe '#reject_upgrade_request' do
    subject { user.reject_upgrade_request }

    before { user.request_upgrade }

    specify do
      expect { subject }.to change(user, :requesting_upgrade?).from(true).to(false)
    end

    specify do
      expect { subject }.to_not change(user, :teacher?)
      expect(user.teacher?).to be false
    end
  end
end
