class LectureDecorator < Draper::Decorator
  delegate_all

  def content_formatted
    h.markdown content
  end

  def attachment_file_size_formatted
    "( #{h.number_to_human_size(attachment_file_size)} )"
  end
end
