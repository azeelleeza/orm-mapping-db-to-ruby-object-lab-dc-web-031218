require "pry"
class Student
  attr_accessor :id, :name, :grade


  def self.new_from_db(row)
    student = new
    student.id = row[0]
    student.name = row[1]
    student.grade = row[2]
    student
  end

  def self.all
    # retrieve all the rows from the "Students" database
    # remember each row should be a new instance of the Student class
    rows=DB[:conn].execute("SELECT * FROM students")
    rows.map{|x| new_from_db(x)}
  end

  def self.find_by_name(name)
    # find the student in the database given a name
    # return a new instance of the Student class
    row=DB[:conn].execute("SELECT * FROM students WHERE name = ?",name)[0]
    new_from_db(row)
  end

  def self.count_all_students_in_grade_9
    sql = <<-SQL
    SELECT *
    FROM students
    WHERE grade = 9
    SQL
    rows = DB[:conn].execute(sql)
    rows.map{|row|new_from_db(row)}
  end

  def self.students_below_12th_grade
    sql = <<-SQL
    SELECT *
    FROM students
    WHERE grade <=11
    SQL
    rows = DB[:conn].execute(sql)
    rows.map{|row|new_from_db(row)}
  end

  def self.first_student_in_grade_10
    sql = <<-SQL
    SELECT *
    FROM students
    WHERE grade = 10
    LIMIT 1
    SQL
    row = DB[:conn].execute(sql)[0]
    new_from_db(row)
  end

  def self.all_students_in_grade_X(grade)
    sql = <<-SQL
    SELECT *
    FROM students
    WHERE grade = ?
    SQL
    rows = DB[:conn].execute(sql,grade)
    rows.map{|row|new_from_db(row)}

  end

  def self.first_X_students_in_grade_10(grade)
    sql = <<-SQL
    SELECT *
    FROM students
    WHERE grade = 10
    LIMIT ?
    SQL
    rows = DB[:conn].execute(sql,grade)
    rows.map{|row|new_from_db(row)}
  end

  def save
    sql = <<-SQL
      INSERT INTO students (name, grade)
      VALUES (?, ?)
    SQL

    DB[:conn].execute(sql, self.name, self.grade)
  end

  def self.create_table
    sql = <<-SQL
    CREATE TABLE IF NOT EXISTS students (
      id INTEGER PRIMARY KEY,
      name TEXT,
      grade TEXT
    )
    SQL

    DB[:conn].execute(sql)
  end

  def self.drop_table
    sql = "DROP TABLE IF EXISTS students"
    DB[:conn].execute(sql)
  end
end
