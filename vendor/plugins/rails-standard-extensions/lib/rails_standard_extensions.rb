class String 
  def /(str_to_join) 
    File.join(self, str_to_join) 
  end 
end

class Object
  def pms
    public_methods.sort.join('  ')
  end
end

class Time
  def to_short
    to_s('')
  end
end

if defined?(ActiveRecord)
  
  class ActiveRecord::Base 
    def helpers
      ActionController::Base.helpers
    end

    def self.dump_to_yaml(dir = nil)
      dir = RAILS_ROOT + (dir || "/db/backup/")
      FileUtils.mkdir_p(dir)
      file = dir + "#{self.table_name}.yml"

      ActiveRecord::Base.transaction do         
        File.open(file, 'w+') do |f| 
          YAML.dump self.find(:all, :order => 'id').collect(&:attributes), f 
        end      
      end
    end

    def self.load_from_yaml(dir = nil)
      dir = RAILS_ROOT + (dir || "/db/backup/")
      file = dir + "#{self.table_name}.yml"

      ActiveRecord::Base.transaction do         
        self.delete_all
        YAML.load_file(file).each do |fixture|
          ActiveRecord::Base.connection.execute "INSERT INTO #{self.table_name} (#{fixture.keys.join(",")}) VALUES (#{fixture.values.collect { |value| ActiveRecord::Base.connection.quote(value) }.join(",")})", 'Fixture Insert'
        end        
      end
    end

    def self.to_fixture
      write_file(File.expand_path("test/fixtures/#{table_name}.yml", RAILS_ROOT), 
        self.find(:all).inject({}) { |hsh, record| 
          hsh.merge("record_#{record.id}" => record.attributes) 
        }.to_yaml)
    end

    def self.write_file(path, content)
      f = File.new(path, "w+")
      f.puts content
      f.close
    end  
  end
end
