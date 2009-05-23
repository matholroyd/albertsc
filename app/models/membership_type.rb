class MembershipType < Struct.new(:id, :name)
  def self.list
    build_list if @list.nil?
    @list
  end
  
  def self.build_list
    add_to_list(1, 'Senior')
    add_to_list(2, 'Family')
    add_to_list(3, 'Junior')
    add_to_list(4, 'Student')
    add_to_list(5, 'Pensioner')
    add_to_list(6, 'Associate')
    add_to_list(7, 'Corporate')
    add_to_list(8, 'Honorary')
    add_to_list(9, 'Life')
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

  def self.add_to_list(id, name)
    @list ||= []
    obj = new(id, name)
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