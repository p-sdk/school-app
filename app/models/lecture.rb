# == Schema Information
#
# Table name: lectures
#
#  id                      :integer          not null, primary key
#  title                   :string
#  content                 :text
#  course_id               :integer          not null
#  created_at              :datetime         not null
#  updated_at              :datetime         not null
#  attachment_file_name    :string
#  attachment_content_type :string
#  attachment_file_size    :integer
#  attachment_updated_at   :datetime
#
# Indexes
#
#  index_lectures_on_course_id  (course_id)
#

class Lecture < ActiveRecord::Base
  belongs_to :course, required: true

  validates :title,
            presence: true,
            length: { in: 3..100 }

  validates :content,
            presence: true,
            length: { maximum: 100_000 }

  has_attached_file :attachment
  do_not_validate_attachment_file_type :attachment
  validates_attachment :attachment, size: { less_than: 25.megabytes }
end
