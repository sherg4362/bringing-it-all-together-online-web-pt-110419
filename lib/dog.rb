class Dog
  attr_accessor :id, :name, :breed
  
  def initialize(attributes)
    @id = id
    @name = name
    @breed = breed
    self.id ||= nil
    attributes.each {|key, value| self.send(("#{key}="), value)}
  end
  
  def self.create_table
    sql = <<-SQL
      CREATE TABLE IF NOT EXISTS dogs(
        id INTEGER PRIMARY KEY,
        name TEXT,
        breed TEXT
      )
        
    SQL
    
    DB[:conn].execute(sql)
  end
  
  def self.drop_table
    sql = "DROP TABLE dogs"
    
    DB[:conn].execute(sql)
  end
  
  def self.new_from_db(row)
    attributes = {
      id: row[0],
      name: row[1],
      breed: row[2]
    }
    self.new(attributes)
  end
  
  def self.find_by_name(name)
    sql = <<-SQL
      SELECT * FROM dogs WHERE name = ?
    SQL
    
    DB[:conn].execute(sql, name).map do |row|
      new_from_db(row)
    end.first
  end
  
  def update
    sql = "UPDATE dogs SET name = ?, breed = ? WHERE id = ?" 
    
    DB[:conn].execute(sql, self.name, self.breed, self.id)
  end
  
  def save
    if self.id
      self.update
    else
      sql = <<-SQL
      INSERT INTO songs (name, breed)
      VALUES (?, ?)
    SQL
    DB[:conn].execute(sql, self.name, self.breed)
    @id = DB[:conn].execute("SELECT last_insert_rowid() FROM dogs")[0][0]
    end
  end
  
end