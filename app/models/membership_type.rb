class MembershipType < Struct.new(:id, :name, :fee)
  def self.list
    build_list if @list.nil?
    @list
  end
  
  def self.build_list
    add_to_list(1, 'Senior', 235)
    add_to_list(2, 'Family', 360)
    add_to_list(3, 'Junior', 100)
    add_to_list(4, 'Student', 150)
    add_to_list(5, 'Pensioner', 150)
    add_to_list(6, 'Associate', 50)
    add_to_list(7, 'Corporate', -9999)
    add_to_list(8, 'Honorary', -9999)
    add_to_list(9, 'Life', -9999)
  end

  def self.selections
    list.collect {|tu| [tu.name, tu.id]}
  end

  def self.find(*args)
    id = args[0]
    list.find { |as| as.id == id }
  end
  
  def self.find_by_name(n)
    list.find { |as| as.name == n }
  end

  def self.add_to_list(id, name, fee)
    @list ||= []
    obj = new(id, name, fee)
    @list << obj
    obj
    const_set name, obj
  end  
    
  def to_s
    name
  end
  
  def new_record? 
    false
  end
  
  def self.const_missing(const)
    build_list
    
    const_get(const)
  end
    
end