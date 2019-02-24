class Dog 
  attr_accessor :name, :breed
  attr_reader :id 
  

    def initialize(id: id = nil, name:, breed:)
        @id = id
        @name = name
        @breed = breed
    end

    def attributes
        self.name
        self.breed
    end
    
    
     
    def self.create_table
        sql = <<-SQL
        CREATE TABLE dogs (
            id INTEGER PRIMARY KEY,
            name TEXT,
            breed TEXT);
        SQL

        DB[:conn].execute(sql)
    end
    
    def save
        if self.id != nil
          self.update
        else
            sql = <<-SQL
            INSERT INTO dogs (name, breed)
            VALUES (?, ?)
            SQL

            DB[:conn].execute(sql, self.name, self.breed)
            @id = DB[:conn].execute("SELECT last_insert_rowid() FROM dogs")[0][0]
        end
        self
    end
    
    
     def self.create(attributes)
        new_dog = Dog.new(attributes)
        attributes.each {|key, value| new_dog.send(("#{key}="), value)}
        new_dog.save
    end
    
    def self.drop_table
        DB[:conn].execute("DROP TABLE dogs;")
    end
    
    def self.new_from_db(row)
      new_dog = self.new(id: row[0], name: row[1], breed: row[2])
      new_dog
    end


    def self.find_by_id(id)
      sql = "SELECT * FROM dogs WHERE id = ? LIMIT 1"
  
      DB[:conn].execute(sql,id).map do |row|
        self.new_from_db(row)
      end.first
    end
    
    def self.find_or_create_by(name:, breed:)
    dog = DB[:conn].execute("SELECT * FROM dogs WHERE name = '#{name}' AND breed = '#{breed}'")
    if !dog.empty?
      dog_info = dog[0]
      dog = Dog.new(id: dog_info[0], name: dog_info[1], breed: dog_info[2])
    else
      dog = self.create(name: name, breed: breed)
    end
    dog
  end
  end