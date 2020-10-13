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

  def self.new_from_db(row)
    #binding.pry
    id = row[0]
    name = row[1]
    breed = row[2]
    self.new(id: id, name: name, breed: breed)
  end

  def self.find_by_name(name)
    sql = <<-SQL
    SELECT *
    FROM dogs
    WHERE name = ?
    LIMIT = 1
    SQL

    DB[:conn].execute(sql,name).map do |row|
      self.new_from_db(row)
    end.first

  end

  def save
    if self.id
      self.update
    else
      sql = <<-SQL
      INSERT INTO dogs (name, breed)
      VALUES (?, ?)
      SQL
    #binding.pry
      saved_dog = DB[:conn].execute(sql, self.name, self.breed)
    #binding.pry
      @id = DB[:conn].execute("SELECT last_insert_rowid() FROM dogs")[0][0]

    end

  #end

  #def update
  #  sql = "UPDATE dogs SET id = ?, name = ?, breed = ?"
  #  DB[:conn].execute(sql, self.id, self.name, self.breed)
  #end

  #def self.create(name:, breed:)
  #  new_dog = Dog.new(name, breed)
  #  new_dog.save
  #  new_dog
  #end



end
