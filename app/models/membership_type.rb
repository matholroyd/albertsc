class MembershipType < Struct.new(:id, :name)
  def self.list
    build_list if @list.nil?
    @list
  end
  
  def self.build_list
    %w{Senior Family Junior Student Pensioner Associate Corporate Honorary Life }.each { |name| add_to_list(name) }
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

  def self.add_to_list(name)
    @list ||= []
    @list << new(@list.length + 1, name)
  end
    
  def to_s
    name
  end
  
  def new_record? 
    false
  end
  
    
end