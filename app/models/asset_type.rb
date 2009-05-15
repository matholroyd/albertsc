class AssetType < Struct.new(:id, :name)
  Boat = AssetType[1, 'Boat']
  ClubKey = AssetType[2, 'ClubKey']
  MiddleRack = AssetType[3, 'Middle Rack']

  def self.list
    @list ||= [Boat, ClubKey, MiddleRack]
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
    
  def to_s
    name
  end
  
  def new_record? 
    false
  end
end