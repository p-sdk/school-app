def name
  "#{Faker::Name.first_name} #{Faker::Name.last_name}"
end

def teacher_name
  "#{name} PhD"
end

def random_text
  rand(3..6).times.map { Faker::Lorem.paragraph(rand 5..15) }.join("\n\n")
end

student = User.create! name: name, email: 'student@example.com',
              password: 'foobar', password_confirmation: 'foobar'
student2 = User.create! name: name, email: 'student2@example.com',
              password: 'foobar', password_confirmation: 'foobar'
teacher = User.create! name: teacher_name, email: 'teacher@example.com',
              password: 'foobar', password_confirmation: 'foobar'
teacher.toggle! :teacher

cat1 = Category.create! name: 'Health'
cat2 = Category.create! name: 'Tech'
cat3 = Category.create! name: 'History'

3.times do
  # name = Faker::Lorem.words(rand 2..4).join(' ').titleize
  name = Faker::Lorem.sentence(rand 2..4)[0...-1].titleize
  desc = random_text
  teacher.teacher_courses.create! name: name, desc: desc, category: cat1
end

c1 = Course.first
c2 = Course.second
student.enroll_in c1
student.enroll_in c2
student2.enroll_in c1

Lecture.create! title: 'Foo Bar', content: random_text, course: c1
Lecture.create! title: 'Occaecat cupidatat', content: random_text, course: c1

t1 = Task.create! title: 'Lorem', desc: random_text, course: c1, points: 100
t2 = Task.create! title: 'Ipsum', desc: random_text, course: c1, points: 50

Solution.create! enrollment: student.enrollments.first,
                 task: t1, content: random_text, earned_points: 70
Solution.create! enrollment: student2.enrollments.first,
                 task: t1, content: random_text
