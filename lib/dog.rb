require 'pry'

class Dog 
  attr_accessor :id, :name, :breed
  def initialize(dog_details)
    @id, @name, @breed = dog_details[:id], dog_details[:name], dog_details[:breed]
  end
  
  def self.create_table
    sql = <<-SQL
        CREATE TABLE IF NOT EXISTS dogs (id INTEGER PRIMARY KEY, name TEXT, breed TEXT)
    SQL
    DB[:conn].execute(sql)
  end
  
  def self.drop_table
    sql = "DROP TABLE IF EXISTS dogs;"
    
    DB[:conn].execute(sql)
  end
  
  def self.create(details)
  
    new_dog = self.new(name: details[:name], breed: details[:breed])
    new_dog.save
    new_dog
  end
  
  def self.new_from_db(row)
    binding.pry
    id = row[0]
    name = row[1]
    grade = row[2]
    self.new()
  end
  
  def self.find_by_id(id_num)
    sql = <<-SQL
      SELECT * FROM dogs WHERE id = ?
    SQL
    DB[:conn].execute(sql, id_num).map do |row|
      self.new_from_db(row)
    end.first
  end
  
  def save
    sql = <<-SQL 
      INSERT INTO dogs (name, breed) VALUES (?, ?)
    SQL
    DB[:conn].execute(sql, self.name, self.breed)
    @id = DB[:conn].execute("SELECT last_insert_rowid() FROM dogs")[0][0]
   self
  end
end