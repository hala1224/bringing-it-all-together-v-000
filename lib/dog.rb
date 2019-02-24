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
    
    
    
  end