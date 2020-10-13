require 'pry'

class Dog
  attr_accessor :id, :name, :breed

  def initialize(id: nil, name:, breed:)
    @id = id
    @name = name
    @breed = breed
  end

  def self.create_table
    sql = <<-SQL
    CREATE TABLE IF NOT EXISTS dogs (
      id INTEGER PRIMARY KEY,
      name TEXT,
      breed TEXT
    )
    SQL

    DB[:conn].execute(sql)
  end

  def self.drop_table
    sql = <<-SQL
    DROP TABLE dogs
    SQL
    DB[:conn].execute(sql)
  end

  def save
    sql = <<-SQL
    INSERT INTO dogs (name, breed)
    VALUES (?, ?)
    SQL
    #binding.pry
    saved_dog = DB[:conn].execute(sql, self.name, self.breed)
    #binding.pry
    @id = DB[:conn].execute("SELECT last_insert_rowid() FROM dogs")[0][0]

  end

  def update
    sql = "UPDATE dogs SET name = ?, breed = ?, id = ?"
    DB[:conn].execute(sql, self.name, self.breed, self.id)
  end

  def self.create(name:, breed:)
    new_dog = Dog.new(name, breed)
    new_dog.save
    new_dog
  end

  def self.new_from_db(row)
    #binding.pry
    id = row[0]
    name = row[1]
    breed = row[2]
    self.new(id:, name:, breed:)

  end

end
