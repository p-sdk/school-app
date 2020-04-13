# == Schema Information
#
# Table name: lectures
#
#  id                      :bigint           not null, primary key
#  attachment_content_type :string
#  attachment_file_name    :string
#  attachment_file_size    :integer
#  attachment_updated_at   :datetime
#  content                 :text
#  title                   :string
#  created_at              :datetime         not null
#  updated_at              :datetime         not null
#  course_id               :integer          not null
#
# Indexes
#
#  index_lectures_on_course_id  (course_id)
#
# Foreign Keys
#
#  fk_rails_...  (course_id => courses.id)
#

require 'rails_helper'

RSpec.describe Lecture do
  subject(:lecture) { build :lecture }

  describe 'validations' do
    it { should belong_to(:course) }

    it { should validate_presence_of(:title) }
    it { should validate_length_of(:title).is_at_least(3).is_at_most(100) }

    it { should validate_presence_of(:content) }
    it { should validate_length_of(:content).is_at_most(100_000) }

    it { should have_attached_file(:attachment) }
    it { should validate_attachment_size(:attachment).less_than(25.megabytes) }
  end
end
