require 'faker'

module FakerHelper
  module_function

  def random_boolean
    Faker::Boolean.boolean
  end

  def random_name
    "#{Faker::Name.first_name} #{Faker::Name.last_name}"
  end

  def random_teacher_name
    "#{random_name} PhD"
  end

  def random_category_name
    Faker::Lorem.words.join(' ').capitalize
  end

  def random_text
    Array.new(rand(3..6)) { Faker::Lorem.paragraph(rand(5..15)) }.join("\n\n")
  end

  def random_sentence
    Faker::Lorem.sentence
  end
end
