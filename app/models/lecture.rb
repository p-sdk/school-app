# == Schema Information
#
# Table name: lectures
#
#  id                      :integer          not null, primary key
#  attachment_content_type :string
#  attachment_file_name    :string
#  attachment_file_size    :bigint
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

class Lecture < ApplicationRecord
  belongs_to :course

  validates :title,
            presence: true,
            length: { in: 3..100 }

  validates :content,
            presence: true,
            length: { maximum: 100_000 }

  has_attached_file :attachment
  do_not_validate_attachment_file_type :attachment
  validates_attachment :attachment, size: { less_than: 25.megabytes }

  def to_param
    "#{id}-#{title}".parameterize
  end
end
